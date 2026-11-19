import os
import subprocess
import tempfile
from pathlib import Path

from .args import SecretsArgs
from .config import SecretsConfig
from .error import SecretsError
from .exec import get_secret, set_secret
from .list import build_file_list
from .meta import SecretsMetadata, get_meta, set_meta

secret_editor = os.getenv("SECRETEDITOR", "nano")

def edit_secret(args: SecretsArgs, config: SecretsConfig):
    if args.secret_name not in config.generators:
        raise SecretsError(f"Invalid secret name '{args.secret_name}'.")
    secret = config.generators[args.secret_name]
    if args.secret_file not in secret.files:
        raise SecretsError(f"Secret '{args.secret_name}' has no file '{args.secret_file}'.")
    file = secret.files[args.secret_file]
    files = build_file_list(args, config)

    print(f"Editing '{args.secret_name}'/'{args.secret_file}'")
    if args.dry_run:
        return

    meta = get_meta(args, config, files, secret) or SecretsMetadata.fresh({})

    with tempfile.TemporaryDirectory() as temp_str:
        temp = Path(temp_str) / "temp_secret"

        if files.has(file.backend, secret.name, file.name):
            get_secret(args, config, secret, file, temp)

        subprocess.run([secret_editor, temp], check=True)
        set_secret(args, config, secret, file, temp)

    meta = SecretsMetadata.fresh(meta.dependencies)
    set_meta(args, config, secret, meta)

    print(f"Updated '{args.secret_name}'/'{args.secret_file}'")
