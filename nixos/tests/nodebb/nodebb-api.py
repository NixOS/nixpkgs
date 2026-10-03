#!/usr/bin/env python3
"""Drive NodeBB the same way test/helpers/index.js does: CSRF from
/api/config, then the v3 write API for login and topic create."""

import json
import os
import sys
import urllib.error
import urllib.request
from http.cookiejar import CookieJar

BASE = os.environ.get("NODEBB_URL", "http://localhost:4567").rstrip("/")
USER = os.environ.get("NODEBB_USER", "admin")
PASSWORD = os.environ.get("NODEBB_PASSWORD", "nodebb-admin-pass")
TITLE = "NixOS integration topic"
STATE = "/tmp/nodebb-tid"

cj = CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))


def request(method, path, data=None, csrf=None):
    url = BASE + path
    body = None if data is None else json.dumps(data).encode()
    req = urllib.request.Request(url, data=body, method=method)
    req.add_header("Accept", "application/json")
    if body is not None:
        req.add_header("Content-Type", "application/json")
    if csrf:
        req.add_header("x-csrf-token", csrf)
    try:
        with opener.open(req) as resp:
            raw = resp.read()
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as e:
        err = e.read().decode("utf-8", "replace")
        raise SystemExit(f"{method} {path} -> {e.code}: {err}") from e


def get(path):
    return request("GET", path)


def post(path, data, csrf):
    return request("POST", path, data, csrf)


def csrf_token():
    cfg = get("/api/config")
    token = cfg.get("csrf_token")
    if not token:
        raise SystemExit(f"no csrf_token in /api/config: {cfg!r}")
    return token


def login():
    return post(
        "/api/v3/utilities/login",
        {"username": USER, "password": PASSWORD},
        csrf_token(),
    )


def phase_setup():
    ping = get("/api/v3/ping")
    if ping.get("status", {}).get("code") != "ok" or not ping.get("response", {}).get("pong"):
        raise SystemExit(f"write API ping failed: {ping!r}")

    categories = get("/api/categories").get("categories") or []
    names = [c.get("name") for c in categories]
    if "General Discussion" not in names:
        raise SystemExit(f"default categories missing: {names!r}")
    cid = next(c["cid"] for c in categories if c.get("name") == "General Discussion")

    session = login()
    user = session.get("response") or {}
    if session.get("status", {}).get("code") != "ok" or not user.get("uid"):
        raise SystemExit(f"login failed: {session!r}")

    # POST /api/v3/ping requires a session and echoes the resolved uid.
    echo = request("POST", "/api/v3/ping", {"probe": True}, csrf_token())
    if echo.get("response", {}).get("uid") != user["uid"]:
        raise SystemExit(f"authenticated ping uid mismatch: {echo!r}")

    created = post(
        "/api/v3/topics",
        {
            "cid": cid,
            "title": TITLE,
            "content": "Posted from the NixOS test.",
        },
        csrf_token(),
    )
    topic = created.get("response") or {}
    if created.get("status", {}).get("code") != "ok" or not topic.get("tid"):
        raise SystemExit(f"topic create failed: {created!r}")
    with open(STATE, "w", encoding="utf-8") as fh:
        fh.write(str(topic["tid"]))
    print(f"created tid={topic['tid']} uid={user['uid']}")


def phase_persist():
    if not os.path.exists(STATE):
        raise SystemExit(f"missing {STATE}")
    tid = open(STATE, encoding="utf-8").read().strip()
    recent = get("/api/recent")
    titles = [t.get("title") for t in recent.get("topics") or []]
    if TITLE not in titles:
        raise SystemExit(f"topic {tid} missing after restart: {titles!r}")
    print(f"topic {tid} still listed on /api/recent")


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "setup"
    if cmd == "setup":
        phase_setup()
    elif cmd == "persist":
        phase_persist()
    else:
        raise SystemExit(f"unknown command: {cmd}")
