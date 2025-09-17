{
  lib,
  stdenv,
  fetchFromGitHub,
  lowdown-unsandboxed,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastchess";
  version = "1.5.0-alpha";

  src = fetchFromGitHub {
    owner = "Disservin";
    repo = "fastchess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hpp10ioAh063LpZa5t2HCX+Fsr8Z6fhPIaTzMgtT1go=";
  };

  nativeBuildInputs = [
    lowdown-unsandboxed
  ];

  postPatch = ''
    substituteInPlace app/Makefile \
      --replace "-march=native" ""
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Versatile command-line tool designed for running chess engine tournaments";
    homepage = "https://github.com/Disservin/fastchess";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Zirconium419122 ];
    platforms = with lib.platforms; unix ++ windows;
    mainProgram = "fastchess";
  };
})
