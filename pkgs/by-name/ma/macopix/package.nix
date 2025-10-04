{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk3,
  openssl,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "macopix";
  version = "3.4.0";

  # GitHub does not contain tags
  # https://github.com/chimari/MaCoPiX/issues/6
  src = fetchurl {
    url = "http://rosegray.sakura.ne.jp/macopix/macopix-${version}.tar.gz";
    hash = "sha256-1AjqdPPCc9UQWqLdWlA+Va+MmvKL8dAIfJURPifN7RI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3
    openssl
  ];

  preConfigure = ''
    # Build fails on Linux with windres.
    export ac_cv_prog_WINDRES=
  '';

  enableParallelBuilding = true;

  # Workaround build failure on -fno-common toolchains:
  #   ld: dnd.o:src/main.h:136: multiple definition of
  #     `MENU_EXT'; main.o:src/main.h:136: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  NIX_LDFLAGS = "-lX11";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Mascot Constructive Pilot for X";
    mainProgram = "macopix";
    homepage = "http://rosegray.sakura.ne.jp/macopix/index-e.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
