from argparse import ArgumentParser
from pathlib import Path

import backgroundremover.utilities as utilities
from backgroundremover import bg

parser = ArgumentParser()

parser.add_argument('input', type=Path)
parser.add_argument('output', type=Path)

args = parser.parse_args()

input_bytes = args.input.read_bytes()

output_bytes = bg.remove(
  input_bytes,
)

args.output.write_bytes(output_bytes)
