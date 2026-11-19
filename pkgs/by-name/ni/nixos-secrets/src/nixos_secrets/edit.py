import os
import subprocess
import tempfile
from pathlib import Path

from .args import SecretsArgs
from .config import SecretsConfig
from .error import SecretsError
from .exec import get_secret, set_secret
from .list import build_file_list

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

    with tempfile.TemporaryDirectory() as temp_str:
        temp = Path(temp_str) / "temp_secret"
        if files.has(file.backend, secret.name, file.name):
            get_secret(args, config, secret, file, temp)
        subprocess.run([secret_editor, temp], check=True)
        set_secret(args, config, secret, file, temp)
        print(f"Updated '{args.secret_name}'/'{args.secret_file}'.")
