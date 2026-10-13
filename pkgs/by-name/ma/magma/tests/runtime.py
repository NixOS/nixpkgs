"""Run installed MAGMA correctness suites on HOST with a real CUDA driver.

Dense upstream tests:
  python3 runtime.py --suite dense --test-output /nix/store/...-magma-...-test \
    --machine aarch64 --evidence-dir ./dense-results
Public sparse consumers built by magma.tests.sparse:
  python3 runtime.py --suite sparse --test-output /nix/store/...-sparse-consumer \
    --magma-output /nix/store/...-magma-... --machine aarch64 \
    --evidence-dir ./sparse-results

Run outside the Nix sandbox. Use --driver-library-path when the NVIDIA driver
is not in /run/opengl-driver/lib. Neither suite replaces private MAGMA sources.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess


COMMON = ["-N", "128", "-N", "256", "--lapack", "--niter", "1"]
DENSE = {
    "sgemm": ["testing_sgemm", *COMMON],
    "sgesv-gpu": ["testing_sgesv_gpu", *COMMON, "--nrhs", "4"],
    "zgemm-nn": ["testing_zgemm", *COMMON, "-NN"],
    "zgemm-cn": ["testing_zgemm", *COMMON, "-CN"],
    "zgesv-gpu": ["testing_zgesv_gpu", *COMMON, "--nrhs", "4"],
    "complex-dot": ["testing_cblas_z", "-N", "17", "-N", "128", "--niter", "1"],
}


def validate_rows(name, rows):
    assert len(rows) == (72 if name == "complex-dot" else 2), len(rows)
    assert all(row.split()[-1] == "ok" for row in rows), "failed numerical row"
    assert not any(re.search(r"\b(?:nan|inf)\b", row, re.I) for row in rows)
    if name == "complex-dot":
        expected = {
            (size, size, size, x, y, operation)
            for size in (17, 128)
            for operation in ("zdotc", "zdotu")
            for x in (-2, -1, 1, 2)
            for y in (-2, -1, 1, 2)
        } | {
            (size, size, size, stride, stride, operation)
            for size in (17, 128)
            for operation in ("dzasum", "dznrm2")
            for stride in (1, 2)
        }
        actual = set()
        for row in rows:
            columns = row.split()
            actual.add((*map(int, columns[:5]), columns[5]))
            # The CBLAS reference may be disabled, but Fortran and inline
            # complex-return conventions must both actually be checked.
            for value in columns[-3:-1]:
                assert 0 <= float(value) < 1e-12, row
        assert actual == expected, (actual - expected, expected - actual)
    else:
        prefix_length = 2 if "gesv" in name else 3
        expected = [(size, 4) if prefix_length == 2 else (size,) * 3 for size in (128, 256)]
        assert [tuple(map(int, row.split()[:prefix_length])) for row in rows] == expected
        for row in rows:
            errors = row.split()[-2:-1] if prefix_length == 2 else row.split()[-3:-1]
            # Additional coarse bound on printed values; upstream applies
            # its tighter precision-dependent tolerance before printing ok.
            limit = 1e-5 if name.startswith("s") else 1e-12
            assert all(0 <= float(error) < limit for error in errors), row


GROUPS = {"memory": 7, "addition": 32, "product": 9, "conversion": 9, "spmv": 8}


def validate_sparse(precision, group, text):
    count = GROUPS[group]
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
    return dict(checks=count, max_absolute_error=max(errors))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--suite", choices=("dense", "sparse"), required=True)
    parser.add_argument("--test-output", type=Path, required=True)
    parser.add_argument("--magma-output", type=Path)
    parser.add_argument("--evidence-dir", type=Path, required=True)
    parser.add_argument("--machine", choices=("aarch64", "x86_64"), required=True)
    parser.add_argument("--driver-library-path", default="/run/opengl-driver/lib")
    args = parser.parse_args()
    sparse = args.suite == "sparse"
    extra = {}
    if sparse:
        if args.magma_output is None:
            parser.error("--magma-output is required for the sparse suite")
        producer = (args.test_output / "share/magma-sparse/producer").read_text().strip()
        assert producer == str(args.magma_output), (producer, str(args.magma_output))
        extra = dict(magma_output=producer,
                     scope="Installed public s/d/c/z sparse APIs; numerical, shape, sparse-index, and basic ownership/status checks. Failure injection and exact resource accounting are separate source-level controls.")
    # Sparse acceptance requires a fresh evidence directory.
    args.evidence_dir.mkdir(parents=True, exist_ok=not sparse)
    home = args.evidence_dir.resolve() / "home"
    home.mkdir(exist_ok=not sparse)
    env = {"HOME": str(home), "PATH": os.defpath,
           "LD_LIBRARY_PATH": args.driver_library_path,
           "OMP_NUM_THREADS": "2", "OPENBLAS_NUM_THREADS": "2"}
    cases = (
        [(f"{p}-{g}", [f"magma-sparse-{p}", g], dict(precision=p, group=g))
         for p in "sdcz" for g in GROUPS]
        if sparse else [(name, command, dict(case=name)) for name, command in DENSE.items()]
    )
    results = []
    for name, command, fields in cases:
        command = [str(args.test_output / "bin" / command[0]), *command[1:]]
        result = dict(fields, command=command, validated=False)
        try:
            binary = Path(command[0]).read_bytes()
            assert binary[:6] == b"\x7fELF\x02\x01", "expected ELF64 little-endian"
            result["elf_machine"] = int.from_bytes(binary[18:20], "little")
            assert result["elf_machine"] == {"aarch64": 183, "x86_64": 62}[args.machine]
            result["binary_sha256"] = hashlib.sha256(binary).hexdigest()
            log = args.evidence_dir / f"{name}.log"
            with log.open("w") as output:
                completed = subprocess.run(command, env=env, stdout=output,
                                           stderr=subprocess.STDOUT, timeout=120)
            result["status"] = completed.returncode
            text = log.read_text()
            assert completed.returncode == 0, completed.returncode
            if sparse:
                result.update(validate_sparse(fields["precision"], fields["group"], text))
            else:
                result["numerical_rows"] = [line for line in text.splitlines() if re.match(r"\s*\d", line)]
                validate_rows(name, result["numerical_rows"])
            result["validated"] = True
        except (AssertionError, OSError, ValueError, subprocess.TimeoutExpired) as error:
            result["error"] = f"{type(error).__name__}: {error}"
        results.append(result)
        print(json.dumps({key: value for key, value in result.items() if key != "numerical_rows"}), flush=True)
    report = dict(extra, test_output=str(args.test_output), machine=args.machine,
                  environment=env, passed=all(case["validated"] for case in results),
                  script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(), results=results)
    (args.evidence_dir / "results.json").write_text(json.dumps(report, indent=2) + "\n")
    raise SystemExit(not report["passed"])


if __name__ == "__main__":
    main()
