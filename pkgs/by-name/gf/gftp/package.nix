{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  gettext,
  gtk2,
  intltool,
  libtool,
  ncurses,
  openssl,
  pkg-config,
  readline,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gftp";
  version = "2.9.1b";

  src = fetchFromGitHub {
    owner = "masneyb";
    repo = "gftp";
    tag = finalAttrs.version;
    hash = "sha256-0zdv2oYl24BXh61IGCWby/2CCkzNjLpDrAFc0J89Pw4=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    intltool
    libtool
    pkg-config
  ];

  buildInputs = [
    gtk2
    ncurses
    openssl
    readline
  ];

  # https://github.com/masneyb/gftp/issues/178
  postPatch = ''
    substituteInPlace lib/gftp.h \
      --replace-fail "size_t remote_addr_len" "socklen_t remote_addr_len"
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  hardeningDisable = [ "format" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/masneyb/gftp";
    description = "GTK-based multithreaded FTP client for *nix-based machines";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.haylin ];
    platforms = lib.platforms.unix;
  };
})
