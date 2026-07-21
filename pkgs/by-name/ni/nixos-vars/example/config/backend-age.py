import tempfile
import sys
import os
import subprocess
import argparse
import json
from pathlib import Path

parser = argparse.ArgumentParser(description="vars-age-backend")
parser.add_argument("config")

subparsers = parser.add_subparsers(
	title="commands", dest="command", required=True
)

get_parser = subparsers.add_parser("get")
get_parser.add_argument("generator")
get_parser.add_argument("filename")

set_parser = subparsers.add_parser("set")
set_parser.add_argument("generator")
set_parser.add_argument("filename")

exists_parser = subparsers.add_parser("exists")
exists_parser.add_argument("generator")
exists_parser.add_argument("filename")

list_parser = subparsers.add_parser("list")

delete_parser = subparsers.add_parser("delete")
delete_parser.add_argument("generator")
delete_parser.add_argument("filename")

fixup_parser = subparsers.add_parser("fixup")
fixup_parser.add_argument("generator")
fixup_parser.add_argument("filename")

args = vars(parser.parse_args())

with open(args["config"]) as f:
	config = json.loads(f.read())

hostDirectory = Path(config["hostDirectory"])


def hostSecretPath(generator=args["generator"], filename=args["filename"]):
	return hostDirectory / "generators" / generator / "files" / filename


def listHostSecrets():
	out = []
	base = hostDirectory
	if base.exists():
		for generator in base.iterdir():
			for file in (generator / "files").iterdir():
				out.append((generator.name, file.name))
	return out


def getSecret(generator, file, outPath):
	identity = config["generators"][generator]["identity"]["host"]
	command = [
		"age",
		"--decrypt",
		"--identity",
		identity,
		"--output",
		outPath,
		hostSecretPath(generator, file),
	]

	subprocess.run(command, check=True)


def setSecret(generator, filename, inPath):
	outPath = hostSecretPath(generator, filename)
	outPath.parent.mkdir(parents=True, exist_ok=True)

	command = ["age", "--encrypt", "--output", outPath]
	for publicKey in config["generators"][generator]["publicKeys"]:
		command += ["--recipient", publicKey]
	command += [inPath]

	subprocess.run(command, check=True)


if args["command"] == "get":
	generator = args["generator"]
	getSecret(generator, args["filename"], os.environ["out"])
elif args["command"] == "set":
	setSecret(args["generator"], args["filename"], os.environ["in"])
elif args["command"] == "exists":
	if not hostSecretPath().exists():
		sys.exit(42)
elif args["command"] == "list":
	for generator, filename in listHostSecrets():
		print(f"{generator} {filename}")
elif args["command"] == "delete":
	hostSecretPath().unlink(missing_ok=True)
elif args["command"] == "fixup":
	with tempfile.NamedTemporaryFile() as fp:
		fp = Path(fp.name)
		generator = args["generator"]
		filename = args["filename"]
		getSecret(generator, filename, fp)
		setSecret(generator, filename, fp)
