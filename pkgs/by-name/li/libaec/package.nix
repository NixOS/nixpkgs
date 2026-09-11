{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libaec";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "Deutsches-Klimarechenzentrum";
    repo = "libaec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aBm+CXCq7sdJb6Qq9sNuTzNj0nRwTJI20HsqUg1Qi/8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/Deutsches-Klimarechenzentrum/libaec/blob/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/Deutsches-Klimarechenzentrum/libaec";
    description = "Adaptive Entropy Coding library";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
