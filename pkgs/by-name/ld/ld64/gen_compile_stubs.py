#!/usr/bin/env python
import sys
from pathlib import Path

byteseq = (str(int(x)) for x in Path(sys.argv[1]).read_bytes())

print("#pragma once")
print(f"static const char compile_stubs[] = {{ {', '.join(byteseq)} }};")
