import json
import os
import sys

dataDir = sys.argv[1]
configPath = sys.argv[2]
mutableUsers = True if sys.argv[3] == "true" else False
users = json.loads(sys.argv[4])


def get_path(user):
    return f"{dataDir}/users/{user}.json"


def get_password(options):
    if options["hashedPasswordFile"] is None:
        return options["hashedPassword"]
    else:
        with open(options["hashedPasswordFile"]) as f:
            return f.readline()


print(f"mutable users = {mutableUsers}")

try:
    os.remove(f"{dataDir}/config.js")
except FileNotFoundError:
    pass

os.symlink(configPath, f"{dataDir}/config.js")

os.makedirs(f"{dataDir}/users", exist_ok=True)

first = []

for (user, options) in users.items():
    path = get_path(user)

    if not os.path.exists(path):
        with open(path, "w") as f:
            json.dump(
                {"password": get_password(options), "log": options["enableLogging"]}, f
            )

        first.append(user)

if mutableUsers:
    path = f"{dataDir}/nixos-users.json"

    nixosUsers = None
    if os.path.exists(path):
        with open(path) as f:
            nixosUsers = json.load(f)

    if nixosUsers is not None:
        for user in nixosUsers.keys():
            if user not in users.keys():
                os.remove(f"{dataDir}/users/{user}.json")

    with open(path, "w") as f:
        json.dump(users, f)
else:
    for user in os.listdir(f"{dataDir}/users"):
        if user.removesuffix(".json") not in users.keys():
            os.remove(f"{dataDir}/users/{user}")

    for (user, options) in users.items():
        if user not in first:
            path = get_path(user)

            user = None
            with open(path) as f:
                user = json.load(f)

            user["password"] = get_password(options)
            user["log"] = options["enableLogging"]

            with open(path, "w") as f:
                json.dump(user, f)
