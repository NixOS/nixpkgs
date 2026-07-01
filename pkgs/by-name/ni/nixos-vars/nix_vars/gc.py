from .args import VarsArgs
from .config import VarsConfig
from .exec import list_secrets, delete_secret


def collect_garbage(args: VarsArgs, config: VarsConfig):
	count = 0
	for backend in config.generatorBackends.values():
		if not backend.list or not backend.delete:
			print(
				f"Skipping '{backend.name}': missing 'list' or 'delete' script"
			)

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

		count += 1
		print(f"Backend '{backend.name}':")
		for gen_name, file_name in sorted(unspecified):
			if args.dry_run:
				print(f"- Would delete '{gen_name}/{file_name}'")
			else:
				print(f"- Deleting '{gen_name}/{file_name}'")
				delete_secret(file, backend, gen_name, file_name)

	print(f"Successfully garbage collected {count} backend(s).")
