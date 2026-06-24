import os
import tempfile
import subprocess
from pathlib import Path
from .args import VarsArgs
from .config import VarsConfig
from .exec import rebuild_order, build_binary, get_secret, set_secret
from .error import VarsError


def generate_vars(args: VarsArgs, config: VarsConfig):
	order = rebuild_order(config)

	try:
		# NOTE: we are going to run the scripts inside bubblewrap, thus sharing a
		# single temporary directory is not a concern.
		with tempfile.TemporaryDirectory() as temp:
			temp = Path(temp)
			for entry in order:
				in_dir = temp / entry / "in"
				out_dir = temp / entry / "out"
				os.makedirs(in_dir)
				os.makedirs(out_dir)

				generator = config.generators[entry]
				binary = build_binary(generator.script)

				for dep_name in generator.dependencies:
					dep = config.generators[dep_name]
					os.makedirs(in_dir / dep_name)
					for file in dep.files:
						get_secret(
							config, dep, file, in_dir / dep_name / file.name
						)

				print(binary, in_dir, out_dir)
				result = subprocess.run(
					[binary],
					env={"in": in_dir, "out": out_dir},
					capture_output=True,
					check=True,
					text=True,
				)

				for file in generator.files:
					set_secret(config, generator, file, out_dir / file.name)

				print(result)
	except subprocess.CalledProcessError as e:
		raise VarsError(f"Error building:\n{e.stderr}")
