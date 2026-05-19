#!/usr/bin/env nix
#!nix shell nixpkgs#python3 --command python

from argparse import ArgumentParser
import pathlib
from urllib.request import build_opener, HTTPCookieProcessor, Request
from http.cookiejar import CookieJar
import json
import time

parser = ArgumentParser()
parser.add_argument("-l", "--language", dest="language", type=str,
                    help="Name of the scripting language", metavar="LANG", required=True)
parser.add_argument("-s", "--script", dest="content_file", type=pathlib.Path,
                    help="read script contents from FILE", metavar="FILE", required=True)
parser.add_argument("-i", "--input", dest="input_file", type=pathlib.Path,
                    help="read script arguments from FILE", metavar="FILE", required=True)

args = parser.parse_args()


cookiejar = CookieJar()
cookieprocessor = HTTPCookieProcessor(cookiejar)
http_client = build_opener(cookieprocessor)

admin_token = None
id_admin_workspace = "admins"


login_form = {"email": "admin@windmill.dev", "password": "changeme"}
login_req = Request(
    "http://localhost:8001/api/auth/login",
    method="POST",
    headers={'Content-Type': 'application/json'},
    data=json.dumps(login_form).encode('utf-8')
)
with http_client.open(login_req) as response:
    assert 200 == response.status, f"Failure {response.status}: Superuser login"
    assert any(cookie.name == "token" for cookie in cookiejar)
    admin_token = next(cookie.value for cookie in cookiejar if cookie.name == "token")
    assert admin_token, "Failed to receive a session key from admin login"


if "python" in args.language:
    # Windmill package recipe requires a manually set default python version in the global instance settings
    python_version_form = {
        # NOTE; Update hardcoded python version below to match the windmill package
        "value": "3.12"
    }
    python_version_req = Request(
        "http://localhost:8001/api/settings/global/instance_python_version",
        method="GET",
        headers={'Authorization': f'Bearer {admin_token}'},
        data=json.dumps(python_version_form).encode('utf-8')
    )
    with http_client.open(python_version_req) as response:
        assert 200 == response.status, f"Failure {response.status}: Update global instance python version."


workspace_req = Request(
    "http://localhost:8001/api/workspaces/list_as_superadmin",
    method="GET",
    headers={'Authorization': f'Bearer {admin_token}'}
)
with http_client.open(workspace_req) as response:
    assert 200 == response.status, f"Failure {response.status}: List workspaces"
    workspace_list = json.loads(response.read().decode('utf-8'))
    assert any(workspace['id'] == id_admin_workspace for workspace in workspace_list)


script_hash = None
script_form = {
    "path": f"u/admin/{args.language}_test",
    "summary": f"Test {args.language}",
    "description": "",
    "language": args.language,
    "content": args.content_file.read_text()
}
script_request = Request(
    f"http://localhost:8001/api/w/{id_admin_workspace}/scripts/create",
    method="POST",
    headers={
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {admin_token}',
    },
    data=json.dumps(script_form).encode('utf-8')
)
with http_client.open(script_request) as response:
    assert 201 == response.status, f"Failure {response.status}: Create {args.language} script"
    script_hash = response.read().decode('utf-8')
    assert script_hash, "Failed to receive an identifier from script creation."

# NOTE; Some languages require dependencies and the depenceny collection tasks take some time to complete
if "bash" not in args.language:
    for i in [1, 2, 3, 4, 5, 6]:
        time.sleep(10)  # seconds
        script_request = Request(
            f"http://localhost:8001/api/w/{id_admin_workspace}/scripts/deployment_status/h/{script_hash}",
            method="GET",
        )
        with http_client.open(script_request) as response:
            try:
                assert 200 == response.status, f"Failure {response.status}: Retrieve {args.language} deployment status"
                script_metadata = json.loads(response.read().decode('utf-8'))
                #
                exists_lock_error = bool(script_metadata["lock_error_logs"])
                assert not exists_lock_error, "Script deployment did not succeed"
                is_deployment_success = script_metadata["lock"] is not None
                if is_deployment_success:
                    break
            except AssertionError:
                # Re-raise error on final attempt
                if i == 6:
                    raise

job_id = None
request = Request(
    f"http://localhost:8001/api/w/{id_admin_workspace}/jobs/run/h/{script_hash}",
    method="POST",
    headers={
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {admin_token}',
    },
    data=args.input_file.read_bytes(),
)
with http_client.open(request) as response:
    assert 201 == response.status, f"Failure {response.status}: Run {args.language} script"
    job_id = response.read().decode('utf-8')
    assert job_id, "Failed to receive an identifier from job creation/scheduling."


started_jobs = set([job_id])
# NOTE; Some languages require script compilation and take longer to run until completion
timeout = 60  # seconds
timeout_end = time.time() + timeout
while any(started_jobs) and time.time() < timeout_end:
    time.sleep(10)  # seconds

    retrieve_jobs_req = Request(
        f"http://localhost:8001/api/w/{id_admin_workspace}/jobs/completed/list",
        method="GET",
        headers={
            'Authorization': f'Bearer {admin_token}',
        },
    )
    with http_client.open(retrieve_jobs_req) as response:
        assert 200 == response.status, f"Failure {response.status}: Retrieve jobs"
        job_results = json.loads(response.read().decode('utf-8'))
        for id in set(started_jobs):  # Must create copy of set being iterated over
            if any(job['id'] == id for job in job_results if bool(job['success'])):
                started_jobs.remove(id)

if any(started_jobs):
    # There are started jobs that have not completed before timeout
    exit(1)
