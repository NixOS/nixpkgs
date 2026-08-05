from .args import VarsArgs
from .config import VarsConfig
from .generate import generate_vars
from .exec import deploy_secrets


def deploy(args: VarsArgs, config: VarsConfig):
    generate_vars(args, config)

    print(f"Running deploy scripts for {len(config.generatorBackends)} backends:")

    for backend in config.generatorBackends.values():
        files = []

        for generator in config.generators.values():
            if generator.backend != backend.name:
                continue

            for file in generator.files.values():
                if file.deploy:
                    files.append((generator.name, file.name))

        if not files:
            print(f"- Skipping '{backend.name}' (no files to deploy)")
            continue

        print(f"- '{backend.name}' ({len(files)} file(s))")
        if not args.dry_run:
            deploy_secrets(args, config, backend, files)
