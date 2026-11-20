{
  lib,
  stdenv,
  fetchFromGitHub,
  lowdown-unsandboxed,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastchess";
  version = "1.8.3-alpha";

  src = fetchFromGitHub {
    owner = "Disservin";
    repo = "fastchess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eFUda+N+3tCYdtNMBRn4+zF6KqiAm46FKc68IfRe/9g=";
  };

  nativeBuildInputs = [
    lowdown-unsandboxed
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace app/Makefile \
      --replace "-march=native" ""
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  passthru = {
    # every upstream release is tagged vX.Y.Z-alpha, which nix-update skips as unstable
    updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };
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
