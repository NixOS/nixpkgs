from .args import SecretsArgs
from .config import SecretsConfig
from .error import SecretsError
from .exec import set_secret
from .list import build_file_list
from .meta import SecretsMetadata, get_meta, set_meta


def import_from_file(args: SecretsArgs, config: SecretsConfig):
    if args.secret_name not in config.generators:
        raise SecretsError(f"Invalid secret name '{args.secret_name}'.")
    secret = config.generators[args.secret_name]
    if args.secret_file not in secret.files:
        raise SecretsError(f"Secret '{args.secret_name}' has no file '{args.secret_file}'.")
    file = secret.files[args.secret_file]

    print(f"Importing '{args.secret_name}'/'{args.secret_file}' from {args.secret_path}")
    if args.dry_run:
        return

    files = build_file_list(args, config)
    meta = get_meta(args, config, files, secret) or SecretsMetadata.fresh({})

    # Will never trigger (argparse would error out beforehand), but it keeps
    # mypy happy...
    assert args.secret_path is not None
    set_secret(args, config, secret, file, args.secret_path)

    meta = SecretsMetadata.fresh(meta.dependencies)
    set_meta(args, config, secret, meta)
    print(f"Updated '{args.secret_name}'/'{args.secret_file}'")
