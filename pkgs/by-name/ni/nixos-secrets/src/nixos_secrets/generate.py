import os
import tempfile
import subprocess
from uuid import uuid4
from pathlib import Path
from typing import Mapping

from .args import SecretsArgs
from .config import SecretsConfig, SecretsSecret
from .meta import SecretsMetadata, VersionID, get_meta, set_meta
from .exec import (
    execution_order,
    build_binary,
    get_secret,
    set_secret,
    fixup_all,
    run_prompt,
    reset_terminal_state,
    file_exists,
)
from .error import SecretsError


def generate_secrets(args: SecretsArgs, config: SecretsConfig):
    forced_regens = set(args.generators + list(args.set.keys()))
    for gen_name in forced_regens:
        if gen_name not in config.generators:
            raise SecretsError(f"Invalid secret name '{gen_name}'")

    order = execution_order(config)

    # Bubblewrap requires usernamespaces to be enabled, so it won't work (by
    # default) in places like Ubuntu. At @Qubasa's suggestion, I have thus made it
    # so a very simple bwrap invocation is used to "test the waters" before running
    # the actual generator scripts inside a sandbox.
    if not args.disable_sandbox:
        try:
            subprocess.run(
                [
                    "bwrap",
                    "--ro-bind",
                    "/",
                    "/",
                    "echo",
                ],
                capture_output=True,
                check=True,
                text=True,
                timeout=1,
            )
        except subprocess.CalledProcessError, subprocess.TimeoutExpired:
            raise SecretsError(
                "Bubblewrap is not available. Either get bubblewrap working or retry with --no-sandbox."
            )

    # NOTE: we are going to run the scripts inside bubblewrap, thus sharing a
    # single temporary directory is not a concern.
    with tempfile.TemporaryDirectory() as temp:
        temp = Path(temp)

        up_to_date_meta = {}
        for entry in order:
            generator = config.generators[entry]

            # The regeneration logic goes as follows:
            # - we regenerate if the user tells us to (via --set or --generate)...
            # - ...or if any dependencies were added/removed...
            # - ...or if any of the dependencies have themselves changed...
            # - ...or if any of the files are missing

            regen = False
            meta = get_meta(args, config, generator)
            if entry in forced_regens:
                print(f"Regenerating '{entry}' (forced)")
                regen = True
            elif meta:
                meta_deps = set(meta.dependencies.keys())
                config_deps = set(generator.dependencies)
                removed_deps = meta_deps - config_deps
                added_deps = config_deps - meta_deps
                if removed_deps:
                    dep_str = ", ".join(sorted(removed_deps))
                    print(f"Regenerating '{entry}' (removed dependencies: {dep_str})")
                    regen = True
                elif added_deps:
                    dep_str = ", ".join(sorted(added_deps))
                    print(f"Regenerating '{entry}' (added dependencies: {dep_str})")
                    regen = True
                else:
                    changed_deps = set()
                    for dep, id in meta.dependencies.items():
                        if id != up_to_date_meta[dep].id:
                            changed_deps.add(dep)
                    if changed_deps:
                        dep_str = ", ".join(sorted(changed_deps))
                        print(
                            f"Regenerating '{entry}' (dependencies changed: {dep_str})"
                        )
                        regen = True
            else:
                print(f"Regenerating '{entry}' (missing metadata)")
                regen = True

            if not regen:
                for file in generator.files.values():
                    backend = config.storeBackends[generator.backend]
                    if not file_exists(args, backend, generator, file):
                        print(f"Regenerating '{entry}' (file '{file.name}' is missing)")
                        regen = True
                        break

            if not regen:
                print(f"Skipping '{entry}'")
                up_to_date_meta[entry] = meta
                continue

            in_dir = temp / "generators" / entry / "in"
            os.makedirs(in_dir)

            out_dir = temp / "generators" / entry / "out"
            os.makedirs(out_dir)

            prompt_in_dir = temp / "generators" / entry / "prompts"
            os.makedirs(prompt_in_dir)

            if generator.prompts and entry not in args.set:
                print(f"Evaluating prompts for '{entry}':")
                for prompt in generator.prompts.values():
                    print(f"- '{prompt.name}'")
                    if not args.dry_run:
                        run_prompt(
                            args,
                            config,
                            generator,
                            prompt,
                            prompt_in_dir / prompt.name,
                        )

            if entry in args.set:
                print(f"Importing '{entry}' from disk")
                if args.dry_run:
                    continue

                set_files_from_dir(args, config, generator, args.set[entry])
            elif generator.generate is not None:
                binary = build_binary(generator.generate)

                print(f"Generating '{entry}'")
                if args.dry_run:
                    continue

                for dep_name in generator.dependencies:
                    dep = config.generators[dep_name]
                    os.makedirs(in_dir / dep_name)
                    for file in dep.files.values():
                        try:
                            get_secret(
                                args,
                                config,
                                dep,
                                file,
                                in_dir / dep_name / file.name,
                            )
                        except subprocess.CalledProcessError as e:
                            raise SecretsError(
                                f"Error getting '{dep_name}/{file.name}': {e.stderr}"
                            )

                try:
                    env = os.environ.copy()
                    env["in"] = in_dir
                    env["out"] = out_dir
                    env["prompts"] = prompt_in_dir

                    if args.disable_sandbox:
                        subprocess.run(
                            [binary],
                            env=env,
                            capture_output=not args.verbose,
                            check=True,
                            text=True,
                            timeout=args.timeout,
                            input="",
                        )
                    else:
                        subprocess.run(
                            [
                                "bwrap",
                                "--unshare-all",
                                "--die-with-parent",
                                "--ro-bind",
                                "/nix/store",
                                "/nix/store",
                                "--ro-bind",
                                "/bin",
                                "/bin",
                                "--ro-bind",
                                "/usr/bin",
                                "/usr/bin",
                                "--ro-bind",
                                in_dir,
                                in_dir,
                                "--ro-bind",
                                prompt_in_dir,
                                prompt_in_dir,
                                "--bind",
                                out_dir,
                                out_dir,
                                "--clearenv",
                                "--setenv",
                                "in",
                                in_dir,
                                "--setenv",
                                "out",
                                out_dir,
                                "--setenv",
                                "prompts",
                                prompt_in_dir,
                                binary,
                            ],
                            capture_output=not args.verbose,
                            check=True,
                            text=True,
                            input="",
                            timeout=args.timeout,
                        )
                except subprocess.CalledProcessError as e:
                    raise SecretsError(f"Error generating '{entry}': {e.stderr}")
                except subprocess.TimeoutExpired:
                    raise SecretsError(f"Generator '{entry}' timed out")
                finally:
                    reset_terminal_state()

                set_files_from_dir(args, config, generator, out_dir)
            else:
                raise SecretsError(
                    f"Secret '{entry}' has no generator script, and no corresponding --set argument was found."
                )

            new_id = str(uuid4())
            dep_ids: Mapping[str, VersionID] = {}
            for dep_name in generator.dependencies:
                dep_ids[dep_name] = up_to_date_meta[dep_name].id
            meta = SecretsMetadata(new_id, dep_ids)

            set_meta(args, config, generator, meta)
            up_to_date_meta[entry] = meta

    print(f"Successfully updated {len(order)} secret(s).")

    fixup_all(args, config)


def set_files_from_dir(
    args: SecretsArgs,
    config: SecretsConfig,
    generator: SecretsSecret,
    from_dir: Path,
):
    for file in generator.files.values():
        if not (from_dir / file.name).exists():
            raise SecretsError(
                f"Cannot update files for '{generator.name}': missing file '{file.name}'"
            )

    for file in generator.files.values():
        try:
            set_secret(args, config, generator, file, from_dir / file.name)
        except subprocess.CalledProcessError as e:
            raise SecretsError(
                f"Error setting '{generator.name}/{file.name}': {e.stderr}"
            )
