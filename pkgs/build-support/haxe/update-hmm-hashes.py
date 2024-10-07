import subprocess
import json
import sys

if len(sys.argv) != 3:
    print(
        "Use: update-hmm-hashes.py <path to input hmm.json> <path to output hashes.json>"
    )
    exit

input_hmm_path = sys.argv[1]
output_hashes_path = sys.argv[2]

hmm_file = open(input_hmm_path)
hmm_json = json.load(hmm_file)
hmm_file.close()

hashes = {}

for dependency in hmm_json["dependencies"]:
    print(dependency)
    if dependency["type"] == "git":
        output = subprocess.check_output(
            [
                "nix-prefetch-git",
                "--url",
                dependency["url"],
                "--rev",
                dependency["ref"],
                "--quiet",
            ]
        )
        hash = json.loads(output)["hash"]
        hashes["git-" + dependency["ref"]] = hash
    elif dependency["type"] == "haxelib":
        url = "http://lib.haxe.org/files/3.0/{}.zip".format(
            "{}-{}".format(dependency["name"], dependency["version"]).replace(".", ",")
        )
        try:
            output_err = subprocess.check_output(
                [
                    "nix-build",
                    "-E",
                    '(import <nixpkgs> {}).fetchzip {url = "'
                    + url
                    + '"; sha256=""; stripRoot=false;}',
                ],
                stderr=subprocess.STDOUT,
            )
        except subprocess.CalledProcessError as e:
            output_err = e.output

        hash = None
        for line in output_err.decode().split("\n"):
            if "   got:" in line:
                hash = line.split("got:")[1].strip()

        if hash is None:
            print("hash not found in output:")
            print(output_err)
            raise BaseException("Hash not found")

        hashes["haxelib-" + dependency["name"] + "-" + dependency["version"]] = hash


hashes_output = open(output_hashes_path, "w")
json.dump(hashes, hashes_output, indent="  ")
hashes_output.close()
