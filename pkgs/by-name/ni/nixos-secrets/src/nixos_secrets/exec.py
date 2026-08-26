import os
import subprocess
import graphlib
import functools
from typing import List, Set, Mapping
from pathlib import Path
from .config import (
    SecretsConfig,
    SecretsStoreBackend,
    SecretsSecret,
    SecretsFile,
    SecretsPrompt,
)
from .error import SecretsError
from .args import SecretsArgs


# Prevents the terminal from getting stuck in an invalid state (i.e. no echo) after, for example, a generator script has finished running.
def reset_terminal_state():
    # https://stackoverflow.com/questions/7938402/terminal-in-broken-state-invisible-text-no-echo-after-exit-during-input
    os.system("stty sane")


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
        raise SecretsError(f"Error building '{path}':\n{e.stderr}")


def backend_env_vars(args: SecretsArgs) -> Mapping[str, str]:
    out = dict()
    if args.json:
        out["NIXOS_SECRETS_CONFIG"] = args.json
    elif args.file:
        out["NIXOS_SECRETS_CONFIG"] = args.file
    elif args.flake:
        out["NIXOS_SECRETS_FLAKE"] = args.flake
    return out


def file_exists(
    args: SecretsArgs,
    backend: SecretsStoreBackend,
    generator: SecretsSecret,
    file: SecretsFile,
) -> bool:
    binary = build_binary(backend.exists)
    env = os.environ.copy()
    env.update(backend_env_vars(args))
    result = subprocess.run(
        [binary, generator.name, file.name],
        capture_output=not args.verbose,
        env=env,
        text=True,
    )

    reset_terminal_state()

    if result.returncode == 42:
        return False

    try:
        result.check_returncode()
        return True
    except subprocess.CalledProcessError as e:
        raise SecretsError(
            f"Error running the '{backend.name}/exists' script for '{generator.name}/{file.name}' [Exit code: {e.returncode}]:\n{e.stderr}"
        )


def get_secret(
    args: SecretsArgs,
    config: SecretsConfig,
    generator: SecretsSecret,
    file: SecretsFile,
    out: Path,
):
    backend = config.storeBackends[generator.backend]
    if backend.get is None:
        raise SecretsError(
            f"Backend '{backend.name}' has no 'get' script, yet the generator ''{generator.name}' requires one"
        )

    binary = build_binary(backend.get)
    try:
        env = os.environ.copy()
        env["out"] = out
        env.update(backend_env_vars(args))
        subprocess.run(
            [binary, generator.name, file.name],
            capture_output=not args.verbose,
            env=env,
            text=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise SecretsError(
            f"Error getting secret '{generator.name}/{file.name}' via the '{backend.name}' backend:\n{e.stderr}"
        )
    finally:
        reset_terminal_state()


def set_secret(
    args: SecretsArgs,
    config: SecretsConfig,
    generator: SecretsSecret,
    file: SecretsFile,
    at: Path,
):
    backend = config.storeBackends[generator.backend]
    binary = build_binary(backend.set)
    try:
        env = os.environ.copy()
        env["in"] = at
        env.update(backend_env_vars(args))
        subprocess.run(
            [binary, generator.name, file.name],
            capture_output=not args.verbose,
            env=env,
            text=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise SecretsError(
            f"Error setting secret '{generator.name}/{file.name}' via the '{backend.name}' backend:\n{e.stderr}"
        )
    finally:
        reset_terminal_state()


# NOTE: we take strings here instead of proper SecretsBackend/SecretsFile object since
# the secrets to be deleted might no longer exist in the configuration (e.g.
# while garbage collecting).
def delete_secret(
    args: SecretsArgs,
    config: SecretsConfig,
    backend: SecretsStoreBackend,
    gen_name: str,
    file_name: str,
):
    binary = build_binary(backend.delete)
    try:
        env = os.environ.copy()
        env.update(backend_env_vars(args))
        subprocess.run(
            [binary, gen_name, file_name],
            capture_output=not args.verbose,
            env=env,
            text=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise SecretsError(
            f"Error deleting secret '{gen_name}/{file_name}' via the '{backend.name}' backend:\n{e.stderr}"
        )
    finally:
        reset_terminal_state()


def list_secrets(
    args: SecretsArgs, config: SecretsConfig, backend: SecretsStoreBackend
) -> Set[tuple[str, str]]:
    binary = build_binary(backend.list)
    try:
        pairs = set()
        env = os.environ.copy()
        env.update(backend_env_vars(args))
        result = subprocess.run(
            [binary],
            capture_output=True,
            text=True,
            check=True,
            env=env,
        )

        for line in result.stdout.strip().split("\n"):
            if not line:
                continue

            parts = line.strip().split()
            if len(parts) == 2:
                pairs.add((parts[0], parts[1]))
            else:
                raise SecretsError(
                    f"Malformed output for list script in backend '{backend.name}': {line}"
                )

        return pairs
    except subprocess.CalledProcessError as e:
        raise SecretsError(
            f"Error listing secrets for the '{backend.name}' backend:\n{e.stderr}"
        )


def deploy_secrets(
    args: SecretsArgs,
    config: SecretsConfig,
    backend: SecretsStoreBackend,
    files: List[tuple[str, str]],
):
    inputLines = []
    for generator, filename in files:
        inputLines.append(f"{generator} {filename}")

    local = args.local is not None
    script = backend.deployLocal if local else backend.deployRemote
    if script is None:
        scriptName = "deploy.local" if local else "deploy.remote"
        raise SecretsError(f"Backend '{backend.name}' has no '{scriptName}' script")

    binary = build_binary(script)
    try:
        env = os.environ.copy()
        env.update(backend_env_vars(args))
        subprocess.run(
            [binary, args.local] if local else [binary],
            input="\n".join(inputLines),
            capture_output=not args.verbose,
            env=env,
            text=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise SecretsError(
            f"Error running deploy via the '{backend.name}' backend:\n{e.stderr}"
        )
    finally:
        reset_terminal_state()


def run_prompt(
    args: SecretsArgs,
    config: SecretsConfig,
    secret: SecretsSecret,
    prompt: SecretsPrompt,
    out: Path,
):
    backend = config.promptBackends[prompt.backend]
    binary = build_binary(backend.ask)
    try:
        env = os.environ.copy()
        env["out"] = out
        env.update(backend_env_vars(args))
        command = [binary, secret.name, prompt.name, prompt.type, prompt.label]
        if prompt.description:
            command.append(prompt.description)
        subprocess.run(
            command,
            env=env,
            check=True,
        )
    except subprocess.CalledProcessError:
        raise SecretsError(
            f"Error running prompt '{prompt.name}' via the '{backend.name}' backend"
        )
    finally:
        reset_terminal_state()


def execution_order(config: SecretsConfig) -> List[str]:
    ts = graphlib.TopologicalSorter()

    for name, gen in config.generators.items():
        ts.add(name, *gen.dependencies)

    try:
        return list(ts.static_order())
    except Exception as e:
        raise SecretsError(f"Dependency cycle detected in configuration:\n{e}")


# Returns a sublist of execution_order which only contains the generators
# that need to be rebuilt.
#
# Optionally accepts a list of generators that must forcefully be included in
# the returned list.
def rebuild_order(
    args: SecretsArgs,
    config: SecretsConfig,
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
                backend = config.storeBackends[generator.backend]
                if not file_exists(args, backend, generator, file):
                    print(f"- '{item}' (file '{file.name}' is missing)")
                    order.append(item)
                    break
            else:
                print(f"- Skipping '{item}'")

    return order


def fixup_all(args: SecretsArgs, config: SecretsConfig):
    print("Running fixup scripts:")

    errors = []
    for backend in config.storeBackends.values():
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
            env = os.environ.copy()
            env.update(backend_env_vars(args))
            subprocess.run(
                [binary, "\n".join(inputLines)],
                capture_output=not args.verbose,
                env=env,
                text=True,
                check=True,
            )
        except subprocess.CalledProcessError as e:
            errors.append(
                f"Error running fixup script for backend '{backend.name}':\n{e.stderr}"
            )
        finally:
            reset_terminal_state()

    if errors:
        raise SecretsError("\n".join(errors))
