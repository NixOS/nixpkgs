import argparse
from pathlib import Path

from trailbase import Client, FetchException

SITE = "http://127.0.0.1:4000"
NOTES_SQL = (
    "CREATE TABLE notes (id INTEGER PRIMARY KEY, body TEXT NOT NULL) STRICT;"
)
RECORD_API = """
record_apis: [{
  name: "notes"
  table_name: "notes"
  acl_authenticated: [CREATE, READ, UPDATE, DELETE]
}]
"""


def connect(password):
    client = Client(SITE)
    client.login("admin@localhost", password)
    user = client.user()
    assert user is not None
    assert user.email == "admin@localhost", user.email
    return client


def setup(password):
    client = connect(password)
    assert client.tokens() is not None
    assert client.refresh_auth_tokens(force=True)
    client.logout()
    assert client.tokens() is None

    client = connect(password)
    client.fetch("api/_admin/query", method="POST", data={"query": NOTES_SQL})
    with Path("/var/lib/trailbase/config.textproto").open("a") as cfg:
        cfg.write(RECORD_API)


def crud(password):
    notes = connect(password).records("notes")
    note_id = notes.create({"body": "hello from nixos"})
    listed = notes.list()
    found = any(note_id.id in str(row) for row in listed.records)
    assert found, listed.records
    assert "hello from nixos" in str(notes.read(note_id))
    notes.update(note_id, {"body": "updated"})
    assert "updated" in str(notes.read(note_id))
    notes.delete(note_id)
    try:
        notes.read(note_id)
    except FetchException:
        return
    raise SystemExit("deleted record still readable")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=["setup", "crud"])
    parser.add_argument("--password", required=True)
    args = parser.parse_args()
    (setup if args.command == "setup" else crud)(args.password)


if __name__ == "__main__":
    main()
