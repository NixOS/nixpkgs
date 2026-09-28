from .args import SecretsArgs
from .config import SecretsConfig, meta_file_name
from .exec import delete_secret, fixup_all
from .list import SecretsFileListEntry, build_file_list


def collect_garbage(args: SecretsArgs, config: SecretsConfig):
    existing = build_file_list(args, config)
    specified: set[SecretsFileListEntry] = set()
    for secret in config.generators.values():
        for file in secret.files.values():
            specified.add(SecretsFileListEntry(secret.backend, secret.name, file.name))
    unspecified = existing.entries - specified

    # The metadata file should only be removed if the secret is no longer part of the config.
    meta_files = set(e for e in unspecified if e.file == meta_file_name)
    for meta_file in meta_files:
        if meta_file.secret in config.generators:
            unspecified.remove(meta_file)

    for backend in config.storeBackends.values():
        if not backend.delete:
            print(f"Skipping '{backend.name}': missing 'delete' script")
            continue

        to_remove = set(e for e in unspecified if e.backend == backend.name)
        if not to_remove:
            print(f"Skipping '{backend.name}': nothing to collect")
            continue

        print(f"Backend '{backend.name}':")
        for entry in to_remove:
            if args.dry_run:
                print(f"- Would delete '{entry.secret}/{entry.file}'")
            else:
                print(f"- Deleting '{entry.secret}/{entry.file}'")
                delete_secret(args, backend, entry.secret, entry.file)

    fixup_all(args, config)
