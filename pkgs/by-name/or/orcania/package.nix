{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  check,
  subunit,
  fetchpatch,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "orcania";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = "orcania";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Cz3IE5UrfoWjMxQ/+iR1bLsYxf5DVN+7aJqLBcPjduA=";
  };

  patches = [
    # fix build w/ glibc-2.44
    (fetchpatch {
      url = "https://github.com/babelouest/orcania/commit/ee2f45b5da8b7fb2c747419c17880ccdca14521d.patch";
      hash = "sha256-BNGL2Q5STrrAO8/OKMS4S5GqlikGnvg4hgBwKTMulgU=";
    })
    (fetchpatch {
      url = "https://github.com/babelouest/orcania/commit/f261393b4dd1b4f50aca389916407e0dfa5f2e55.patch";
      hash = "sha256-KyRedPj5gBFPZmefmjLL49OY8eJNmMyd5jsFsQByTUE=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [
    check
    subunit
  ];

  cmakeFlags = [ "-DBUILD_ORCANIA_TESTING=on" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=constant-conversion"
    ]
  );

  doCheck = true;

  meta = {
    description = "Potluck with different functions for different purposes that can be shared among C programs";
    mainProgram = "base64url";
    homepage = "https://github.com/babelouest/orcania";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ johnazoidberg ];
  };
})
