import json
import os
from dataclasses import dataclass
from pathlib import Path
from string import Template
from typing import Any


@dataclass
class Runner:
    name: str
    tokenFile: str

    id: str
    token: str


@dataclass
class Machines:
    gitlab: Any
    gitlab_runner: Any


@dataclass
class Nix:
    jq: str
    gitlab_state_path: str
    create_runner_payload_file: str
    runner_token_env_file: str


# Some global variables to work in the tests.
out_dir = os.environ.get("out", os.getcwd())
nix = Nix(
    jq=JQ_BINARY,
    gitlab_state_path=GITLAB_STATE_PATH,
    create_runner_payload_file=CREATE_RUNNER_PAYLOAD_FILE,
    runner_token_env_file=RUNNER_TOKEN_ENV_FILE,
)
vms = Machines(gitlab, gitlab_runner)
runnerConfigs: dict[str, Runner] = {}
rootPAT = "root-PAT-01234567890"


def wait_for_services():
    vms.gitlab.wait_for_unit("gitaly.service")
    vms.gitlab.wait_for_unit("gitlab-workhorse.service")
    vms.gitlab.wait_for_unit("gitlab.service")
    vms.gitlab.wait_for_unit("gitlab-sidekiq.service")
    vms.gitlab.wait_for_file(f"{nix.gitlab_state_path}/tmp/sockets/gitlab.socket")
    vms.gitlab.wait_until_succeeds("curl -sSf http://gitlab/users/sign_in")


def test_connection():
    """
    Test the connection to Gitlab and check if it is reachable from the runner VM.
    """

    print("==> Getting secrets and headers.")
    vms.gitlab.succeed(
        "cp /var/gitlab/state/config/secrets.yml /root/gitlab-secrets.yml"
    )

    vms.gitlab.succeed(
      f"/run/wrappers/bin/sudo -u gitlab gitlab-rails runner \"token = User.find_by_username('root').personal_access_tokens.create(scopes: ['api'], name: 'Test Token', expires_at: 365.days.from_now); token.set_token('{rootPAT}'); token.save!\""
    )

    print("==> Testing connection.")
    vms.gitlab_runner.succeed(f"curl -v -H 'Authorization: Bearer {rootPAT}' http://gitlab/api/v4/version")


def test_register_runner(name: str, tokenFile: str):
    """
    Register the runner in Gitlab and write the token file to be picked up by
    the gitlab-runner service on the other VM.
    """

    r = Runner(
        name=name,
        tokenFile=tokenFile,
        token="",
        id="",
    )
    runnerConfigs[r.name] = r

    print(f"==> Create Runner '{r.name}'")
    resp = vms.gitlab.execute(
        f"""
    curl -s -X POST \
        -H 'Content-Type: application/json' \
        -H 'Authorization: Bearer {rootPAT}' \
        -d @{nix.create_runner_payload_file} \
        http://gitlab/api/v4/user/runners
    """
    )[1]
    obj = json.loads(resp)
    r.id = obj["id"]
    r.token = obj["token"]
    print(f"==> Registered runner '{r.id}' with token '{r.token}'.")

    # Push the token to the runner machine.
    print("==> Push runner token to machine.")
    tokenF = Path(out_dir, f"token-{r.name}.env")
    with open(nix.runner_token_env_file, "r") as f:
        tokenData = Template(f.read()).substitute({"token": r.token})
    with open(tokenF, "w") as w:
        w.write(tokenData)
    vms.gitlab_runner.copy_from_host(str(tokenF), r.tokenFile)


def restart_gitlab_runner_service(runnerConfigs):
    print("==> Restart Gitlab Runner")

    if len(runnerConfigs) == 0:
        raise Exception("You must have at least one runner registered!")

    if any([n == "podman" for n in runnerConfigs.keys()]):
        vms.gitlab_runner.wait_for_unit("podman-nix-daemon-container.service")
        vms.gitlab_runner.wait_for_unit("podman-podman-daemon-container.service")

    vms.gitlab_runner.systemctl("restart gitlab-runner.service")
    vms.gitlab_runner.wait_for_unit("gitlab-runner.service")


def test_runner_registered(r: Runner):
    """
    Test that the runner `r` is registered in Gitlab and its status is active.
    """

    print(f"==> Check that runner '{r.name}' is registered.")

    resp = vms.gitlab.execute(
        f"""
        curl -s -X GET \
        -H 'Content-Type: application/json' \
        -H 'Authorization: Bearer {rootPAT}' \
        http://gitlab/api/v4/runners/{r.id}"""
    )[1]
    runnerStatus = json.loads(resp)

    if not runnerStatus["active"]:
        raise Exception(
            f"Runner '{r.name}' [id: '{r.id}'] status is not active: {resp}"
        )
