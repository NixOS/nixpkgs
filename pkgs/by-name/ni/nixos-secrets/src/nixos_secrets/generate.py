import os
import tempfile
import subprocess
from pathlib import Path
from .args import SecretsArgs
from .config import SecretsConfig
from .exec import (
    rebuild_order,
    build_binary,
    get_secret,
    set_secret,
    fixup_all,
    run_prompt,
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
            if generator.prompts:
                print(f"Evaluating prompts for '{entry}':")
                for prompt in generator.prompts.values():
                    print(f"- '{prompt.name}'")
                    if not args.dry_run:
                        run_prompt(config, prompt, prompt_in_dir / prompt.name)

            if entry in args.set:
                print(f"Importing '{entry}' from disk")
                raise SecretsError(
                    "Setting files using the CLI hasn't been implemented yet...."
                )
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
                                f"Error getting '{entry}/{file.name}': {e.stderr}"
                            )

                try:
                    env = os.environ.copy()
                    env["in"] = in_dir
                    env["out"] = out_dir

                    if args.disable_sandbox:
                        subprocess.run(
                            [binary],
                            env=env,
                            capture_output=not args.verbose,
                            check=True,
                            text=True,
                        )
                    else:
                        subprocess.run(
                            [
                                "bwrap",
                                "--unshare-all",
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
                        )
                except subprocess.CalledProcessError as e:
                    raise SecretsError(f"Error generating '{entry}': {e.stderr}")

                for file in generator.files.values():
                    try:
                        set_secret(args, config, generator, file, out_dir / file.name)
                    except subprocess.CalledProcessError as e:
                        raise SecretsError(
                            f"Error setting '{entry}/{file.name}': {e.stderr}"
                        )
            else:
                raise SecretsError(
                    f"Secret '{entry}' has no generator script, and no corresponding --set argument was found."
                )

    print(f"Successfully (re)run {len(order)} generator(s).")

    fixup_all(args, config)
