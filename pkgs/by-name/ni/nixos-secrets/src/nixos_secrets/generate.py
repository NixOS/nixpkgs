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
    order = rebuild_order(args, config, args.generators)

    for gen_name in args.generators:
        if gen_name not in config.generators:
            raise SecretsError(f"Invalid generator '{gen_name}'")

    # NOTE: we are going to run the scripts inside bubblewrap, thus sharing a
    # single temporary directory is not a concern.
    with tempfile.TemporaryDirectory() as temp:
        temp = Path(temp)

        print("Evaluating prompts:")

        prompt_dir = temp / "prompts"
        os.makedirs(prompt_dir)

        for prompt in config.prompts.values():
            required_by = []
            for gen_name in order:
                generator = config.generators[gen_name]
                if prompt.name in generator.prompts:
                    required_by.append(gen_name)

            if required_by:
                requirements = ", ".join(f"'{r}'" for r in required_by)
                print(f"- '{prompt.name}' (required by {requirements})")

                if not args.dry_run:
                    run_prompt(config, prompt, prompt_dir / prompt.name)
            else:
                print(f"- Skipping '{prompt.name}'")

        for entry in order:
            in_dir = temp / "generators" / entry / "in"
            os.makedirs(in_dir)

            out_dir = temp / "generators" / entry / "out"
            os.makedirs(out_dir)

            prompt_in_dir = temp / "generators" / entry / "prompts"
            os.makedirs(prompt_in_dir)

            generator = config.generators[entry]
            binary = build_binary(generator.script)

            print(f"Generating '{entry}'")
            if args.dry_run:
                continue

            for name in generator.prompts:
                (prompt_dir / name).copy(prompt_in_dir / name)

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

    print(f"Successfully (re)run {len(order)} generator(s).")

    fixup_all(args, config)
