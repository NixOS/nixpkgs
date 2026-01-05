{
  stdenv,
  lib,
  fetchFromGitHub,
  glib,
  readline,
  bison,
  flex,
  pkg-config,
  autoreconfHook,
  txt2man,
  which,
  gettext,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdbtools";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mdbtools";
    repo = "mdbtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XWkFgQZKx9/pjVNEqfp9BwgR7w3fVxQ/bkJEYUvCXPs=";
  };

  configureFlags = [ "--disable-scrollkeeper" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=unused-but-set-variable";

  nativeBuildInputs = [
    pkg-config
    bison
    flex
    autoreconfHook
    txt2man
    which
  ];

  buildInputs = [
    glib
    readline
  ];

  postUnpack = ''
    cp -v ${gettext}/share/gettext/m4/lib-{link,prefix,ld}.m4 source/m4
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/mdb-ver";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/mdbtools/mdbtools/releases/tag/v${finalAttrs.version}";
    description = ".mdb (MS Access) format tools";
    homepage = "https://mdbtools.github.io/";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2
    ];
    platforms = lib.platforms.unix;
  };
})
