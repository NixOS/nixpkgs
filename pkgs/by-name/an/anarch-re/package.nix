{
  lib,
  stdenv,
  fetchFromSourcehut,
  sdl3,
  pkg-config,
  buildPackages,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anarch-re";
  version = "2";

  src = fetchFromSourcehut {
    owner = "~marcin-serwin";
    repo = "anarch-re";
    rev = "z${finalAttrs.version}";
    hash = "sha256-k8zCLhcynVStaql4eGl0HFrLwF0WWfz4Prxn3x5Exxk=";
  };

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sdl3
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  dontConfigure = true;

  makeFlags = [
    "EXE=${stdenv.hostPlatform.extensions.executable}"
    "PREFIX=${placeholder "out"}"
    "HOSTCC=$(CC_FOR_BUILD)"
    "VERSION_NUMBER=${finalAttrs.version}" # TODO: Remove when updating to z3
    "VERSION_SUFFIX=-nixpkgs"
    "CFLAGS=-O3"
  ];

  doCheck = true;
  doInstallCheck = true;

  meta = {
    homepage = "https://git.sr.ht/~marcin-serwin/anarch-re";
    description = "Public domain from-scratch suckless Doom clone";
    maintainers = with lib.maintainers; [
      dvn0
      marcin-serwin
    ];
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
    mainProgram = "anarch-re";
  };
})
