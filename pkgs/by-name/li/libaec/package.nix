{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libaec";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "Deutsches-Klimarechenzentrum";
    repo = "libaec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wfCgIKHBFNAU80jzZwh4KYkp/GaExJmRK0z/fNUzJ9o=";
  };

  nativeBuildInputs = [
    cmake
  ];

  strictDeps = true;

  doCheck = true;

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/Deutsches-Klimarechenzentrum/libaec/blob/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/Deutsches-Klimarechenzentrum/libaec";
    description = "Adaptive Entropy Coding library";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
