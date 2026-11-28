{
  lib,
  leanPackages,
  fetchpatch,
  fetchFromGitHub,
}:

leanPackages.buildLakePackage {
  pname = "lean4lean";
  version = "0-unstable-2026-09-09";

  isLibrary = false;

  src = fetchFromGitHub {
    # https://github.com/leanprover/lean4/blob/v4.36.0/src/CMakeLists.txt#L1045
    owner = "Kha";
    repo = "lean4lean";
    tag = "lean4-bundle-4.35";
    hash = "sha256-VTxvXgJrHeY4ZFRHuyCVFS+iMhTIgTn2h9CWK3BuA9k=";
  };

  patches = [
    # Lean 4.36.0 compatibility patch missing from Kha's fork
    (fetchpatch {
      name = "lean-4.36.patch";
      url = "https://github.com/digama0/lean4lean/commit/23fd0341e823a332ce5df21a1897c8afcbf34471.patch";
      includes = [
        "Lean4Lean/Environment/Basic.lean"
        "Lean4Lean/Std/Basic.lean"
      ];
      hash = "sha256-ldNyRyU32ocGvd4Fw6BcNt+wndwaVXsB45GEAcnyw8E=";
    })

    # Avoid a dependency on `lean4export` now that its functionality is in the `LeanExport` core library
    ./no-lean4export.patch
  ];

  leanDeps = with leanPackages; [
    batteries
  ];

  buildTargets = [ "lean4lean" ];

  meta = {
    description = "Lean 4 kernel / 'external checker' written in Lean 4";
    license = lib.licenses.asl20;
    homepage = "https://github.com/digama0/lean4lean";
    maintainers = with lib.maintainers; [
      alejo7797
      stephen-huan
    ];
  };
}
