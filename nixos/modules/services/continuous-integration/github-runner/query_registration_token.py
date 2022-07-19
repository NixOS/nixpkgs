import argparse
import json
import logging
from urllib.request import urlopen, Request
from urllib.parse import urlparse
from urllib.error import HTTPError


def new_registration_token_from_pat(url: str, pat: str) -> str:
    """Queries a new registration token for a github.com repository or organisation"""
    components = urlparse(url)
    if components.netloc not in {"github.com", "github.com:443"}:
        raise ValueError("Only PATs for github.com are supported!")

    path_parts = [x for x in components.path.split("/") if x]
    if len(path_parts) == 1:
        logging.debug("Given URL is for a Github organization")
        endpoint = (
            "https://api.github.com/orgs/{}/actions/runners/registration-token".format(
                path_parts[0]
            )
        )
    else:
        logging.debug("Given URL is for a single Github repository")
        endpoint = "https://api.github.com/repos/{}/{}/actions/runners/registration-token".format(
            *path_parts
        )

    req = Request(
        endpoint,
        method="POST",
        headers={
            "Authorization": f"token {pat}",
            "Accept": "application/vnd.github+json",
        },
    )
    logging.debug(f"Performing API call to {endpoint}")
    try:
        with urlopen(req) as resp:
            return json.load(resp)["token"]
    except HTTPError as err:
        raise RuntimeError(
            "Caught unexpected status {err.status} while getting registration token:\n{err.read().decode()}"
        ) from err


def get_registration_token(token_file: str, url: str) -> str:
    """Return a runner registration token.

    If the given token file contains a PAT, use it to request a new registration token from GitHub.
    If the file's content is not a PAT, use it as a registration token directly.
    """
    with open(token_file) as f:
        token = f.read().strip()

    is_pat = token.startswith("ghp_")
    if is_pat:
        logging.info("Read token file contains a PAT")
        registration_token = new_registration_token_from_pat(url, token)
    else:
        logging.info("Read token file is not a PAT; using as registration token")
        registration_token = token

    return registration_token


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--token-file",
        "-t",
        help="Path to a file which contains either a runner registration token or a PAT suitable to request a new registration token from GitHub",
    )
    parser.add_argument("--url", "-u", help="The registration URL of the runner")
    parser.add_argument("--log-level", "-l", default="INFO")
    args = parser.parse_args()

    logging.basicConfig(
        format="%(filename)s %(levelname)s: %(message)s", level=args.log_level.upper()
    )

    registration_token = get_registration_token(args.token_file, args.url)

    print(registration_token, end="")
