from .args import SecretsArgs
from .config import SecretsConfig
from .error import SecretsError
from .exec import set_secret


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

    # Will not trigger (argparse would error out beforehand), but this keeps
    # mypy happy...
    assert args.secret_path is not None
    set_secret(args, config, secret, file, args.secret_path)
