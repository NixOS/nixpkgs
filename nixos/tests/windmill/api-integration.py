#!/usr/bin/env nix
#!nix shell nixpkgs#python3 --command python

import json
import time
from urllib.request import build_opener, HTTPCookieProcessor, Request
from http.cookiejar import CookieJar

cookiejar = CookieJar()
cookieprocessor = HTTPCookieProcessor(cookiejar)
http_request = build_opener(cookieprocessor)

admin_token = None
id_admin_workspace = "admins"
python_script_hash = None
started_jobs = set()

login_form = {"email": "admin@windmill.dev", "password": "changeme"}
login_req = Request(
    "http://localhost:8001/api/auth/login",
    method="POST",
    headers={'Content-Type': 'application/json'},
    data=json.dumps(login_form).encode('utf-8')
)
with http_request.open(login_req) as response:
    assert 200 == response.status, "Failure: Login"
    assert any(cookie.name == "token" for cookie in cookiejar)
    admin_token = next(cookie.value for cookie in cookiejar if cookie.name == "token")
    assert admin_token


workspace_req = Request(
    "http://localhost:8001/api/workspaces/list_as_superadmin",
    method="GET",
    headers={'Authorization': f'Bearer {admin_token}'}
)
with http_request.open(workspace_req) as response:
    assert 200 == response.status, "Failure: List workspaces"
    workspace_list = json.loads(response.read().decode('utf-8'))
    assert any(workspace['id'] == id_admin_workspace for workspace in workspace_list)


python_script_form = {
    "path": "u/admin/python_test",
    "summary": "Test Python",
    "description": "",
    "language": "python3",
    "content": "def main():\n\t\treturn 'ok'",
}
python_script_req = Request(
    f"http://localhost:8001/api/w/{id_admin_workspace}/scripts/create",
    method="POST",
    headers={
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {admin_token}',
    },
    data=json.dumps(python_script_form).encode('utf-8')
)
with http_request.open(python_script_req) as response:
    assert 201 == response.status, "Failure: Create python script"
    python_script_hash = response.read().decode('utf-8')


python_run_script_form = {}
python_run_script_req = Request(
    f"http://localhost:8001/api/w/{id_admin_workspace}/jobs/run/h/{python_script_hash}",
    method="POST",
    headers={
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {admin_token}',
    },
    data=json.dumps(python_run_script_form).encode('utf-8')
)
with http_request.open(python_run_script_req) as response:
    assert 201 == response.status, "Failure: Run python script"
    started_jobs.add(response.read().decode('utf-8'))


print(started_jobs)

timeout = 300  # seconds
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
    with http_request.open(retrieve_jobs_req) as response:
        assert 200 == response.status, "Failure: Retrieve jobs"
        job_results = json.loads(response.read().decode('utf-8'))
        for job_id in set(started_jobs):  # Must create copy of set being iterated over
            if any(job['id'] == job_id for job in job_results if bool(job['success'])):
                started_jobs.remove(job_id)

if any(started_jobs):
    # There are started jobs that have not completed before timeout
    exit(1)
