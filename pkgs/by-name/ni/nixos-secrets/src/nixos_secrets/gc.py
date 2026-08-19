from .args import SecretsArgs
from .config import SecretsConfig
from .exec import list_secrets, delete_secret, fixup_all


def collect_garbage(args: SecretsArgs, config: SecretsConfig):
    for backend in config.generatorBackends.values():
        if not backend.list or not backend.delete:
            print(f"Skipping '{backend.name}': missing 'list' or 'delete' script")

            continue

        secrets = list_secrets(config, backend)
        specified = set()
        for generator in config.generators.values():
            for file in generator.files.values():
                specified.add((generator.name, file.name))

        unspecified = secrets - specified
        if not unspecified:
            print(f"Skipping '{backend.name}': nothing to collect")
            continue

        print(f"Backend '{backend.name}':")
        for gen_name, file_name in sorted(unspecified):
            if args.dry_run:
                print(f"- Would delete '{gen_name}/{file_name}'")
            else:
                print(f"- Deleting '{gen_name}/{file_name}'")
                delete_secret(args, file, backend, gen_name, file_name)

    fixup_all(args, config)
