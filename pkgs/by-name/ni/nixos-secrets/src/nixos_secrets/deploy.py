from .args import SecretsArgs
from .config import SecretsConfig
from .generate import generate_secrets
from .exec import deploy_secrets


def deploy(args: SecretsArgs, config: SecretsConfig):
    generate_secrets(args, config)

    print(f"Running deploy scripts for {len(config.generatorBackends)} backends:")

    for backend in config.generatorBackends.values():
        files = config.files_for_backend(backend, no_local=True)

        if not files:
            print(f"- Skipping '{backend.name}' (no files to deploy)")
            continue

        print(f"- '{backend.name}' ({len(files)} file(s))")
        if not args.dry_run:
            deploy_secrets(args, config, backend, files)
