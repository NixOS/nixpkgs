#!@PYTHON@

import json
import os
import re
import shlex
import sqlite3
import subprocess
import sys


DB_PATH = os.path.join(os.environ['HOME'], '.config/Signal/sql/db.sqlite')
DB_COPY = os.path.join(os.environ['HOME'], '.config/Signal/sql/db.tmp')
CONFIG_PATH = os.path.join(os.environ['HOME'], '.config/Signal/config.json')


def zenity_askyesno(title, text):
    args = [
        '@ZENITY@',
        '--question',
        '--title',
        shlex.quote(title),
        '--text',
        shlex.quote(text)
    ]
    return subprocess.run(args).returncode == 0


def start_signal():
    os.execvp('@SIGNAL-DESKTOP@', ['@SIGNAL-DESKTOP@'] + sys.argv[1:])


def copy_pragma(name):
    result = subprocess.run([
        '@SQLCIPHER@',
        DB_PATH,
        f"PRAGMA {name};"
    ], check=True, capture_output=True).stdout
    result = re.search(r'[0-9]+', result.decode()).group(0)
    subprocess.run([
        '@SQLCIPHER@',
        DB_COPY,
        f"PRAGMA key = \"x'{key}'\"; PRAGMA {name} = {result};"
    ], check=True, capture_output=True)


try:
    # Test if DB is encrypted:
    con = sqlite3.connect(f'file:{DB_PATH}?mode=ro', uri=True)
    cursor = con.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    con.close()
except:
    # DB is encrypted, everything ok:
    start_signal()


# DB is unencrypted!
answer = zenity_askyesno(
        "Error: Signal-Desktop database is not encrypted",
        "Should we try to fix this automatically?"
        + "You likely want to backup ~/.config/Signal/ first."
)
if not answer:
    answer = zenity_askyesno(
            "Launch Signal-Desktop",
            "DB is unencrypted, should we still launch Signal-Desktop?"
            + "Warning: This could result in data loss!"
    )
    if not answer:
        print('Aborted')
        sys.exit(0)
    start_signal()

# Re-encrypt the DB:
with open(CONFIG_PATH) as json_file:
    key = json.load(json_file)['key']
result = subprocess.run([
    '@SQLCIPHER@',
    DB_PATH,
    f" ATTACH DATABASE '{DB_COPY}' AS signal_db KEY \"x'{key}'\";"
    + " SELECT sqlcipher_export('signal_db');"
    + " DETACH DATABASE signal_db;"
]).returncode
if result != 0:
    print('DB encryption failed')
    sys.exit(1)
# Need to copy user_version and schema_version manually:
copy_pragma('user_version')
copy_pragma('schema_version')
os.rename(DB_COPY, DB_PATH)
start_signal()
