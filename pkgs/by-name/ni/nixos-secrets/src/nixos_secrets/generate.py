import os
import tempfile
import subprocess
import functools
from pathlib import Path
from .args import SecretsArgs
from .config import SecretsConfig, SecretsSecret
from .exec import (
    rebuild_order,
    build_binary,
    get_secret,
    set_secret,
    fixup_all,
    run_prompt,
    reset_terminal_state,
)
from .error import SecretsError


def generate_secrets(args: SecretsArgs, config: SecretsConfig):
    order_seed = args.generators + list(args.set.keys())
    for gen_name in order_seed:
        if gen_name not in config.generators:
            raise SecretsError(f"Invalid secret name '{gen_name}'")

    order = rebuild_order(args, config, order_seed)

    # NOTE: we are going to run the scripts inside bubblewrap, thus sharing a
    # single temporary directory is not a concern.
    with tempfile.TemporaryDirectory() as temp:
        temp = Path(temp)

        for entry in order:
            in_dir = temp / "generators" / entry / "in"
            os.makedirs(in_dir)

            out_dir = temp / "generators" / entry / "out"
            os.makedirs(out_dir)

            prompt_in_dir = temp / "generators" / entry / "prompts"
            os.makedirs(prompt_in_dir)

            generator = config.generators[entry]
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

                    if args.disable_sandbox or not bwrap_is_available():
                        subprocess.run(
                            [binary],
                            env=env,
                            capture_output=not args.verbose,
                            check=True,
                            text=True,
                            timeout=args.timeout,
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


# Bubblewrap requires usernamespaces to be enabled, so it won't work (by
# default) in places like Ubuntu. At @Qubasa's suggestion, I have thus made it
# so a very simple bwrap invocation is used to "test the waters" before running
# the actual generator scripts inside a sandbox.
@functools.cache
def bwrap_is_available() -> bool:
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

        return True
    except subprocess.CalledProcessError, subprocess.TimeoutExpired:
        print("Bubblewrap not avaiable. Running without a sandbox!")
        return False
