from .args import VarsArgs
from .config import VarsConfig
from .exec import rebuild_order


def generate_vars(args: VarsArgs, config: VarsConfig):
	ro = rebuild_order(config)

	# print("Rebuild order:")
	# for name in ro:
	# 	print(f"- {name}")
	#
	# 	# generator = config.generators[name]
	# 	# if not generator_needs_run(var, backend, rebuilt):
	# 	# 	print("  -> Skipping (already exists)")
	# 	# 	continue
