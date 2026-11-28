#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 nix gitMinimal
import base64
import concurrent.futures
import json
import os
import re
import subprocess
import sys
import threading
import time
import urllib.error
import urllib.request
from pathlib import Path

git_root = subprocess.check_output(
    ["git", "rev-parse", "--show-toplevel"], text=True
).strip()
maintainers_list_nix = Path(git_root) / "maintainers/maintainer-list.nix"

if not os.environ.get("GH_TOKEN"):
    sys.exit(
        "Set GH_TOKEN before running this script, eg. export GH_TOKEN=$(gh auth token)"
    )
token = os.environ.get("GH_TOKEN")

# Load maintainers list into memory as JSON
out = subprocess.check_output(
    [
        "nix-instantiate",
        "--json",
        "--eval",
        "--strict",
        "--expr",
        f"builtins.fromJSON (builtins.toJSON (import {maintainers_list_nix.resolve()}))",
    ]
)
maintainers_json = json.loads(out)

file_lock = threading.Lock()
rate_limit_lock = threading.Lock()
rate_limit_reset = 0

GRAPHQL_QUERY = """
query($ids: [ID!]!) {
  nodes(ids: $ids) {
    ... on User {
      login
    }
  }
}
"""


def fetch_batch_graphql(node_ids):
    global rate_limit_reset
    req = urllib.request.Request(
        "https://api.github.com/graphql",
        data=json.dumps(
            {"query": GRAPHQL_QUERY, "variables": {"ids": node_ids}}
        ).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
            "User-Agent": "nixpkgs-fix-maintainers",
        },
    )

    while True:
        with rate_limit_lock:
            now = time.time()
            if rate_limit_reset > now:
                time.sleep(rate_limit_reset - now)

        try:
            with urllib.request.urlopen(req, timeout=20) as resp:
                headers = resp.headers
                remaining = headers.get("X-RateLimit-Remaining")
                if remaining == "0":
                    reset_ts = headers.get("X-RateLimit-Reset")
                    if reset_ts:
                        with rate_limit_lock:
                            rate_limit_reset = int(reset_ts) + 5
                            print(
                                f"Request limit exceeded, waiting until {time.ctime(int(reset_ts))}",
                                flush=True,
                            )

                data = json.loads(resp.read().decode("utf-8"))
                return data.get("data", {}).get("nodes", [])
        except urllib.error.HTTPError as e:
            remaining = e.headers.get("X-RateLimit-Remaining")
            if remaining == "0" or e.code == 403:
                reset_ts = e.headers.get("X-RateLimit-Reset")
                if reset_ts:
                    with rate_limit_lock:
                        rate_limit_reset = int(reset_ts) + 5
                        print(
                            f"Request limit exceeded, waiting until {time.ctime(int(reset_ts))}",
                            flush=True,
                        )
                    continue
            return [None] * len(node_ids)
        except Exception:
            return [None] * len(node_ids)


def process_batch(batch):
    node_ids = []
    for k, v in batch:
        gid = v.get("githubId")
        # Global ID encoding: base64("04:User<githubId>")
        node_id = base64.b64encode(f"04:User{gid}".encode("utf-8")).decode("utf-8")
        node_ids.append(node_id)

    nodes = fetch_batch_graphql(node_ids)

    for (k, v), node in zip(batch, nodes):
        current_user = v.get("github")
        if not node:
            print(f"{k} likely deleted their github account", flush=True)
            continue

        api_user = node.get("login")
        if not api_user:
            continue

        if current_user is None:
            print(f"{k} is known on github as {api_user}.", flush=True)
        elif current_user.lower() != api_user.lower():
            print(
                f"{k} is now known on github as {api_user}. Editing maintainer-list.nix…",
                flush=True,
            )
            with file_lock:
                content = maintainers_list_nix.read_text(encoding="utf-8")
                new_content, count = re.subn(
                    rf'github = "{re.escape(current_user)}";$',
                    f'github = "{api_user}";',
                    content,
                    flags=re.MULTILINE,
                )
                if count > 0:
                    maintainers_list_nix.write_text(new_content, encoding="utf-8")


def main():
    valid_maintainers = []

    for k, v in maintainers_json.items():
        if v.get("github") is None:
            print(f"{k} has no github handle", flush=True)
        if v.get("githubId") is None:
            print(f"{k} has no githubId", flush=True)
            continue
        valid_maintainers.append((k, v))

    # Batch into chunks of 100 users per GraphQL request
    chunk_size = 100
    batches = [
        valid_maintainers[i : i + chunk_size]
        for i in range(0, len(valid_maintainers), chunk_size)
    ]

    # Run batches with 6 concurrent workers (54 batches total)
    max_workers = min(6, len(batches)) or 1
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [executor.submit(process_batch, b) for b in batches]
        concurrent.futures.wait(futures)


if __name__ == "__main__":
    main()
