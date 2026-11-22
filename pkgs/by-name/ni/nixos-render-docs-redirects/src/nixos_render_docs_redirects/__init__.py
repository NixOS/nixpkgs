import argparse
import json
import sys
from pathlib import Path


def add_content(redirects: dict[str, list[str]], identifier: str, path: str) -> dict[str, list[str]]:
    if identifier in redirects:
        raise IdentifierExists(identifier)

    # Insert the new identifier in alphabetical order
    new_redirects = list(redirects.items())
    insertion_index = 0
    for i, (key, _) in enumerate(new_redirects):
        if identifier > key:
            insertion_index = i + 1
        else:
            break
    new_redirects.insert(insertion_index, (identifier, [f"{path}#{identifier}"]))
    return dict(new_redirects)


def move_content(redirects: dict[str, list[str]], identifier: str, path: str) -> dict[str, list[str]]:
    if identifier not in redirects:
        raise IdentifierNotFound(identifier)
    redirects[identifier].insert(0, f"{path}#{identifier}")
    return redirects


def rename_identifier(
    redirects: dict[str, list[str]],
    old_identifier: str,
    new_identifier: str
) -> dict[str, list[str]]:
    if old_identifier not in redirects:
        raise IdentifierNotFound(old_identifier)
    if new_identifier in redirects:
        raise IdentifierExists(new_identifier)

    # To minimise the diff, we recreate the redirects mapping allowing
    # the new key to be updated in-place, preserving the index.
    new_redirects = {}
    current_path = ""
    for key, value in redirects.items():
        if key == old_identifier:
            new_redirects[new_identifier] = value
            current_path = value[0].split('#')[0]
            continue
        new_redirects[key] = value
    new_redirects[new_identifier].insert(0, f"{current_path}#{new_identifier}")
    return new_redirects


def remove_and_redirect(
    redirects: dict[str, list[str]],
    old_identifier: str,
    new_identifier: str
) -> dict[str, list[str]]:
    if old_identifier not in redirects:
        raise IdentifierNotFound(old_identifier)
    if new_identifier not in redirects:
        raise IdentifierNotFound(new_identifier)
    redirects[new_identifier].extend(redirects.pop(old_identifier))
    return redirects


def main():
    parser = argparse.ArgumentParser(description="redirects manipulation for nixos manuals")
    commands = parser.add_subparsers(dest="command", required=True)
    parser.add_argument("-f", "--file", type=Path, required=True)

    add_content_cmd = commands.add_parser("add-content")
    add_content_cmd.add_argument("identifier", type=str)
    add_content_cmd.add_argument("path", type=str)

    move_content_cmd = commands.add_parser("move-content")
    move_content_cmd.add_argument("identifier", type=str)
    move_content_cmd.add_argument("path", type=str)

    rename_id_cmd = commands.add_parser("rename-identifier")
    rename_id_cmd.add_argument("old_identifier", type=str)
    rename_id_cmd.add_argument("new_identifier", type=str)

    remove_redirect_cmd = commands.add_parser("remove-and-redirect")
    remove_redirect_cmd.add_argument("identifier", type=str)
    remove_redirect_cmd.add_argument("target_identifier", type=str)

    args = parser.parse_args()

    with open(args.file) as file:
        redirects = json.load(file)

    try:
        if args.command == "add-content":
            redirects = add_content(redirects, args.identifier, args.path)
            print(f"Added new identifier: {args.identifier}")

        elif args.command == "move-content":
            redirects = move_content(redirects, args.identifier, args.path)
            print(f"Moved '{args.identifier}' to the new path: {args.path}")

        elif args.command == "rename-identifier":
            redirects = rename_identifier(redirects, args.old_identifier, args.new_identifier)
            print(f"Renamed identifier from {args.old_identifier} to {args.new_identifier}")

        elif args.command == "remove-and-redirect":
            redirects = remove_and_redirect(redirects, args.identifier, args.target_identifier)
            print(f"Redirect from '{args.identifier}' to '{args.target_identifier}' added.")
    except Exception as error:
        print(error, file=sys.stderr)
    else:
        with open(args.file, "w") as file:
            json.dump(redirects, file, indent=2)
            file.write("\n")


class IdentifierExists(Exception):
    def __init__(self, identifier: str):
        self.identifier = identifier

    def __str__(self):
        return f"The identifier '{self.identifier}' already exists."


class IdentifierNotFound(Exception):
    def __init__(self, identifier: str):
        self.identifier = identifier

    def __str__(self):
        return f"The identifier '{self.identifier}' does not exist in the redirect mapping."
