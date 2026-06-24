from .args import VarsArgs
from .config import VarsConfig


def generate_vars(args: VarsArgs, config: VarsConfig):
	print(config.executionOrder())
