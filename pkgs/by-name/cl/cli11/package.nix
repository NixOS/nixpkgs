{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  catch2,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cli11";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${finalAttrs.version}";
    hash = "sha256-73dfpZDnKl0cADM4LTP3/eDFhwCdiHbEaGRF7ZyWsdQ=";
  };

  buildInputs = [ catch2 ];
  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [
    boost
    python3
  ];

  doCheck = true;
  strictDeps = true;

  meta = {
    description = "Command line parser for C++11";
    homepage = "https://github.com/CLIUtils/CLI11";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
})
