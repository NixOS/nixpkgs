import json
import os
import re
import sys

VAR_RE = re.compile(
    r"\$\$|\$([A-Za-z_][A-Za-z0-9_]*)|(?:\$\{([A-Za-z_][A-Za-z0-9_]*)\})"
)


def sub(m):
    if m.group(0) == "$$":
        return "$"
    var = m.group(1) or m.group(2)
    if var not in os.environ:
        sys.exit(
            f"Error: environment variable '{var}' referenced in "
            "configuration is not set"
        )
    return os.environ[var]


def walk(n):
    if isinstance(n, dict):
        return {k: walk(v) for k, v in n.items()}
    if isinstance(n, list):
        return [walk(v) for v in n]
    if isinstance(n, str):
        res = VAR_RE.sub(sub, n)
        if res.startswith("json::"):
            return json.loads(res[6:])
        return res
    return n


with open(sys.argv[1]) as f:
    data = json.load(f)

with open(sys.argv[2], "w") as f:
    json.dump(walk(data), f)
