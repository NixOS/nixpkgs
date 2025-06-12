import sys
import os.path
from configobj import ConfigObj, ParseError

base = ConfigObj()

for path in sys.argv[1:]:
    if os.path.isfile(path):
        with open(path) as f:
            try:
              update = ConfigObj(f)
              base.merge(update)
            except ParseError as e:
              raise Exception(f"Failed to merge {path}") from e
    else:
        raise Exception(f"Instructed to merge {path} but not found or not a file")

for line in base.write():
    print(line)
