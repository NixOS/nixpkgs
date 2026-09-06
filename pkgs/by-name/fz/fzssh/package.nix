{
  fetchurl,
  lib,
  libargon2,
  libfilezilla,
  meson,
  nettle,
  ninja,
  pkg-config,
  stdenv,
  testers,

  autoreconfHook,
  gettext,
  gnutls,
  libiconv,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fzssh";
  version = "1.3.0";
  __structuredAttrs = true;

  src = fetchurl {
    # Upstream download link was made unstable on purpose
    # See https://trac.filezilla-project.org/ticket/13186
    url = "https://sources.archlinux.org/other/packages/fzssh/fzssh-${finalAttrs.version}.tar.xz";
    hash = "sha256-hkWCsgNyZYi1oW2GFB/5Wrd9I5l2L+u+H97ZLk8EeZY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libargon2
    libfilezilla
    nettle
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

  meta = {
    homepage = "https://lib.filezilla-project.org/";
    description = "SSH/SFTP library based on libfilezilla";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    pkgConfigModules = [ "libfzssh-client" ];
  };
})
