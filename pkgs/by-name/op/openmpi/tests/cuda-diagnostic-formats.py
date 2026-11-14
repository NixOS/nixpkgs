#!/usr/bin/env python3
"""Compile and execute exact CUDA help formats with their callers' argument types."""
import argparse
import json
from pathlib import Path
import re
import shlex
import subprocess
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("source", type=Path, help="Open MPI source after applying patches")
parser.add_argument("--cc", default="cc")
parser.add_argument("--expect-invalid", action="store_true")
args = parser.parse_args()
help_file = args.source / "opal/mca/accelerator/cuda/help-accelerator-cuda.txt"
sections = dict(re.findall(r"^\[([^\]]+)\]\n(.*?)(?=^\[|\Z)", help_file.read_text(), re.M | re.S))
# Mirror the actual call-site types, including a count exceeding 32 bits.
cases = {
    "cuMemHostRegister failed": "pointer, count, host, status",
    "cuMemHostRegister during init failed": 'pointer, count, host, status, "checkmem"',
    "cuMemHostUnregister failed": "pointer, host, status",
    "cuMemcpyAsync failed": "pointer, pointer, count, status",
}
formats = {name: "\n".join(line for line in sections[name].splitlines() if not line.startswith("#")) + "\n" for name in cases}
body = "\n".join(f"  printf({json.dumps(formats[name])}, {arguments});" for name, arguments in cases.items())
program = """#include <stdio.h>
#include <stdint.h>
int main(void) {
  int object;
  void *pointer = &object;
  size_t count = ((size_t) 1 << 33) + 17;
  const char *host = "format-control-host";
  int status = 1;
""" + body + "\n  return 0;\n}\n"
with tempfile.TemporaryDirectory(prefix="mpi-cuda-formats-") as work:
    source = Path(work) / "formats.c"
    binary = Path(work) / "formats"
    source.write_text(program)
    command = shlex.split(args.cc) + ["-Wall", "-Wextra", "-Wformat=2", "-Werror=format", "-fsanitize=address,undefined", "-g", str(source), "-o", str(binary)]
    compiled = subprocess.run(command, text=True, capture_output=True)
    print(compiled.stderr, end="")
    if args.expect_invalid:
        assert compiled.returncode != 0, "Original malformed formats unexpectedly compiled"
        assert "format" in compiled.stderr, "Compilation did not fail with a format diagnostic"
        print("PASS: original help formats rejected by compiler")
    else:
        compiled.check_returncode()
        executed = subprocess.run([str(binary)], text=True, capture_output=True)
        print(executed.stdout, end="")
        print(executed.stderr, end="")
        executed.check_returncode()
        assert executed.stdout.count("8589934609") == 3, "Byte count was truncated"
        assert executed.stdout.count("Registration cache:") == 1, "Unexpected registration-cache field"
        assert "Registration cache:  checkmem" in executed.stdout
        assert not executed.stderr, "Sanitizer emitted diagnostics"
        print("PASS: corrected help formats preserve size_t and caller arguments under ASan/UBSan")
