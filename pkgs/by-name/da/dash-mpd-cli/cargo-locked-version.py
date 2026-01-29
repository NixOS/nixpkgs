import sys
import tomllib

with open(sys.argv[1], "rb") as fp:
    lockfile = tomllib.load(fp)

print([p["version"] for p in lockfile["package"] if p["name"] == sys.argv[2]][0])
