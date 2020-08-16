import json
import pathlib
import shutil
import subprocess
import tempfile
from typing import Dict


WRAPPER_SOURCE = pathlib.Path(__file__).parent / "wrapper.nim"

NIM_EXECUTABLE = "nim"
STRIP_EXECUTABLE = "strip"


def compile_wrapper(instruction: Dict):
    """Compile a wrapper using the given instruction."""

    with tempfile.TemporaryDirectory() as tmpdir:
        tmpdir = pathlib.Path(tmpdir)
        shutil.copyfile(WRAPPER_SOURCE, tmpdir / "wrapper.nim" )
        with open(tmpdir / "wrapper.json", "w") as fout:
            json.dump(instruction, fout)
        subprocess.run(
            f"cd {tmpdir} && {NIM_EXECUTABLE} --nimcache=. --gc:none -d:release --opt:size compile {tmpdir}/wrapper.nim && {STRIP_EXECUTABLE} -s {tmpdir}/wrapper",
            shell=True,
        )
        shutil.move(tmpdir / "wrapper", instruction["wrapper"])
        