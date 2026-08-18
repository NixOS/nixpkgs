import os
import subprocess
import graphlib
import functools
from typing import List, Set
from pathlib import Path
from .config import (
    VarsConfig,
    VarsGeneratorBackend,
    VarsGenerator,
    VarsFile,
    VarsPrompt,
)
from .error import VarsError
from .args import VarsArgs


@functools.cache
def build_binary(path: Path) -> Path:
    try:
        result = subprocess.run(
            ["nix-store", "--realise", path],
            capture_output=True,
            text=True,
            check=True,
        )

        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        raise VarsError(f"Error building '{path}':\n{e.stderr}")


def file_exists(
    args: VarsArgs,
    backend: VarsGeneratorBackend,
    generator: VarsGenerator,
    file: VarsFile,
) -> bool:
    binary = build_binary(backend.exists)
    result = subprocess.run(
        [binary, generator.name, file.name],
        capture_output=not args.verbose,
        text=True,
    )

    if result.returncode == 42:
        return False

    try:
        result.check_returncode()
        return True
    except subprocess.CalledProcessError as e:
        raise VarsError(
            f"Error running the '{backend.name}/exists' script for '{generator.name}/{file.name}' [Exit code: {e.returncode}]:\n{e.stderr}"
        )


def get_secret(
    args: VarsArgs,
    config: VarsConfig,
    generator: VarsGenerator,
    file: VarsFile,
    out: Path,
):
    backend = config.generatorBackends[generator.backend]
    if backend.get is None:
        raise VarsError(
            f"Backend '{backend.name}' has no 'get' script, yet the generator ''{generator.name}' requires one"
        )

    binary = build_binary(backend.get)
    try:
        env = os.environ.copy()
        env["out"] = out
        subprocess.run(
            [binary, generator.name, file.name],
            capture_output=not args.verbose,
            text=True,
            check=True,
            env=env,
        )
    except subprocess.CalledProcessError as e:
        raise VarsError(
            f"Error getting secret '{generator.name}/{file.name}' via the '{backend.name}' backend:\n{e.stderr}"
        )


def set_secret(
    args: VarsArgs,
    config: VarsConfig,
    generator: VarsGenerator,
    file: VarsFile,
    at: Path,
):
    backend = config.generatorBackends[generator.backend]
    binary = build_binary(backend.set)
    try:
        env = os.environ.copy()
        env["in"] = at
        subprocess.run(
            [binary, generator.name, file.name],
            capture_output=not args.verbose,
            text=True,
            check=True,
            env=env,
        )
    except subprocess.CalledProcessError as e:
        raise VarsError(
            f"Error setting secret '{generator.name}/{file.name}' via the '{backend.name}' backend:\n{e.stderr}"
        )


# NOTE: we take strings here instead of proper VarsBackend/VarsFile object since
# the secrets to be deleted might no longer exist in the configuration (e.g.
# while garbage collecting).
def delete_secret(
    args: VarsArgs,
    config: VarsConfig,
    backend: VarsGeneratorBackend,
    gen_name: str,
    file_name: str,
):
    binary = build_binary(backend.delete)
    try:
        subprocess.run(
            [binary, gen_name, file_name],
            capture_output=not args.verbose,
            text=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise VarsError(
            f"Error deleting secret '{gen_name}/{file_name}' via the '{backend.name}' backend:\n{e.stderr}"
        )


def list_secrets(
    config: VarsConfig, backend: VarsGeneratorBackend
) -> Set[tuple[str, str]]:
    binary = build_binary(backend.list)
    try:
        pairs = set()
        result = subprocess.run(
            [binary],
            capture_output=True,
            text=True,
            check=True,
        )

        for line in result.stdout.strip().split("\n"):
            if not line:
                continue

            parts = line.strip().split()
            if len(parts) == 2:
                pairs.add((parts[0], parts[1]))
            else:
                raise VarsError(
                    f"Malformed output for list script in backend '{backend.name}': {line}"
                )

        return pairs
    except subprocess.CalledProcessError as e:
        raise VarsError(
            f"Error listing secrets for the '{backend.name}' backend:\n{e.stderr}"
        )


def deploy_secrets(
    args: VarsArgs,
    config: VarsConfig,
    backend: VarsGeneratorBackend,
    files: List[tuple[str, str]],
):
    inputLines = []
    for generator, filename in files:
        inputLines.append(f"{generator} {filename}")

    local = args.local is not None
    script = backend.deployLocal if local else backend.deployRemote
    if script is None:
        scriptName = "deploy.local" if local else "deploy.remote"
        raise VarsError(f"Backend '{backend.name}' has no '{scriptName}' script")

    binary = build_binary(script)
    try:
        subprocess.run(
            [binary, args.local] if local else [binary],
            input="\n".join(inputLines),
            capture_output=not args.verbose,
            text=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise VarsError(
            f"Error running deploy via the '{backend.name}' backend:\n{e.stderr}"
        )


def run_prompt(config: VarsConfig, prompt: VarsPrompt, out: Path):
    backend = config.promptBackends[prompt.backend]
    binary = build_binary(backend.script)
    try:
        env = os.environ.copy()
        env["out"] = out
        command = [binary, prompt.type, prompt.label]
        if prompt.description:
            command.append(prompt.description)
        subprocess.run(
            command,
            env=env,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise VarsError(
            f"Error running prompt '{prompt.name}' via the '{backend.name}' backend:\n{e.stderr}"
        )


def execution_order(config: VarsConfig) -> List[str]:
    ts = graphlib.TopologicalSorter()

    for name, gen in config.generators.items():
        ts.add(name, *gen.dependencies)

    try:
        return list(ts.static_order())
    except Exception as e:
        raise VarsError(f"Dependency cycle detected in configuration:\n{e}")


# Returns a sublist of execution_order which only contains the generators
# that need to be rebuilt.
#
# Optionally accepts a list of generators that must forcefully be included in
# the returned list.
def rebuild_order(
    args: VarsArgs,
    config: VarsConfig,
    regenerate: List[str],
) -> List[str]:
    order = []

    print("Rebuild order:")
    for item in execution_order(config):
        generator = config.generators[item]

        if item in regenerate:
            print(f"- '{item}' (forced)")
            order.append(item)
            continue

        for dep in generator.dependencies:
            if dep in order:
                print(f"- '{item}' (dependency '{dep}' has changed)")
                order.append(item)
                break
        else:
            for file in generator.files.values():
                backend = config.generatorBackends[generator.backend]
                if not file_exists(args, backend, generator, file):
                    print(f"- '{item}' (file '{file.name}' is missing)")
                    order.append(item)
                    break
            else:
                print(f"- Skipping '{item}'")

    return order


def fixup_all(args: VarsArgs, config: VarsConfig):
    print("Running fixup scripts:")

    errors = []
    for backend in config.generatorBackends.values():
        files = config.files_for_backend(backend)

        if not backend.fixup:
            print(f"- Skipping '{backend.name}' (no fixup script)")
            continue
        elif not files:
            print(f"- Skipping '{backend.name}' (no files)")
            continue
        else:
            print(f"- '{backend.name}' ({len(files)} file(s))")

        if args.dry_run:
            continue

        inputLines = []
        for generator, filename in files:
            inputLines.append(f"{generator} {filename}")

        binary = build_binary(backend.fixup)
        try:
            subprocess.run(
                [binary, "\n".join(inputLines)],
                capture_output=not args.verbose,
                text=True,
                check=True,
            )
        except subprocess.CalledProcessError as e:
            errors.append(
                f"Error running fixup script for backend '{backend.name}':\n{e.stderr}"
            )

    if errors:
        raise VarsError("\n".join(errors))
