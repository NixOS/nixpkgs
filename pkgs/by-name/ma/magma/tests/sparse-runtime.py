"""Run the installed public sparse consumer on HOST with a real CUDA driver.

Build magma.tests.sparse first, then execute outside the Nix sandbox:
  python3 sparse-runtime.py --test-output /nix/store/...-sparse-consumer \
    --magma-output /nix/store/...-magma-2.9.0 --machine aarch64 \
    --evidence-dir ./sparse-results --driver-library-path /run/opengl-driver/lib

No private MAGMA source replacement or resource interposition is used here.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

GROUPS = {"memory": 7, "addition": 32, "product": 9, "conversion": 9, "spmv": 8}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--test-output", type=Path, required=True)
    parser.add_argument("--magma-output", type=Path, required=True)
    parser.add_argument("--machine", choices=("aarch64", "x86_64"), required=True)
    parser.add_argument("--evidence-dir", type=Path, required=True)
    parser.add_argument("--driver-library-path", default="/run/opengl-driver/lib")
    args = parser.parse_args()
    producer = (args.test_output / "share/magma-sparse/producer").read_text().strip()
    assert producer == str(args.magma_output), (producer, str(args.magma_output))
    # A new directory is required, so an old success cannot be reused.
    args.evidence_dir.mkdir(parents=True, exist_ok=False)
    home = args.evidence_dir.resolve() / "home"
    home.mkdir()
    env = {"HOME": str(home), "PATH": os.defpath,
           "LD_LIBRARY_PATH": args.driver_library_path,
           "OMP_NUM_THREADS": "2", "OPENBLAS_NUM_THREADS": "2"}
    results = []
    for precision in "sdcz":
        binary = args.test_output / "bin" / f"magma-sparse-{precision}"
        data = binary.read_bytes()
        assert data[:6] == b"\x7fELF\x02\x01", "expected ELF64 little endian"
        machine = int.from_bytes(data[18:20], "little")
        assert machine == {"aarch64": 183, "x86_64": 62}[args.machine]
        for group, count in GROUPS.items():
            command = [str(binary), group]
            name = f"{precision}-{group}"
            result = {"precision": precision, "group": group, "command": command,
                      "elf_machine": machine, "binary_sha256": hashlib.sha256(data).hexdigest(),
                      "validated": False}
            log = args.evidence_dir / f"{name}.log"
            try:
                with log.open("w") as output:
                    completed = subprocess.run(command, env=env, stdout=output,
                                               stderr=subprocess.STDOUT, timeout=120)
                result["status"] = completed.returncode
                text = log.read_text()
                assert completed.returncode == 0, completed.returncode
                rows = [line for line in text.splitlines() if line.startswith("PASS ")]
                assert len(rows) == count, (len(rows), count)
                expected = f"SUCCESS precision={precision} group={group} checks={count}"
                assert expected in text.splitlines(), expected
                errors = []
                for line in rows:
                    match = re.fullmatch(r"PASS .* error=(\S+)", line)
                    assert match, line
                    errors.append(float(match[1]))
                assert all(0 <= error < float("inf") for error in errors), errors
                result.update(validated=True, checks=count, max_absolute_error=max(errors))
            except (AssertionError, OSError, ValueError, subprocess.TimeoutExpired) as error:
                result["error"] = f"{type(error).__name__}: {error}"
            results.append(result)
            print(json.dumps(result), flush=True)
    report = {"passed": all(case["validated"] for case in results),
              "test_output": str(args.test_output), "magma_output": producer,
              "machine": args.machine, "environment": env,
              "script_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
              "scope": "Installed public s/d/c/z sparse APIs; numerical, shape, sparse-index, and basic ownership/status checks. Failure injection and exact resource accounting are separate source-level controls.",
              "results": results}
    (args.evidence_dir / "results.json").write_text(json.dumps(report, indent=2) + "\n")
    raise SystemExit(not report["passed"])


if __name__ == "__main__":
    main()
