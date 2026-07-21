from .args import VarsArgs
from .config import VarsConfig
from .generate import generate_vars
from .exec import deploy_secrets


def deploy(args: VarsArgs, config: VarsConfig):
	generate_vars(args, config)

	print(
		f"Running deploy scripts for {len(config.generatorBackends)} backends:"
	)

	for backend in config.generatorBackends.values():
		print(f"- '{backend.name}'")
		if not args.dry_run:
			deploy_secrets(args, config, backend)
