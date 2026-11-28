{
  lib,
  leanPackages,
  fetchFromGitHub,
}:

leanPackages.buildLakePackage {
  pname = "con-leche";
  version = "0-unstable-2026-11-17";

  isLibrary = false;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "con-leche";
    # Make sure https://github.com/leanprover/con-leche/blob/${rev}/lean-toolchain matches our `lean4`
    rev = "cd2eceab2e9b10404c663b468639c8aa99d0d1f2";
    hash = "sha256-UyimwRmQCLG/SPnFdezKL8hdQ1SVIy0m4u9LCIp0rHY=";
  };

  meta = {
    description = "External lean checker with a proof of consistency";
    license = lib.licenses.asl20;
    homepage = "https://github.com/leanprover/con-leche";
    maintainers = with lib.maintainers; [
      alejo7797
      stephen-huan
    ];
  };
}
