{
  directoryListingUpdater,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fzssh";
  version = "1.5.0";
  __structuredAttrs = true;

  src = fetchurl {
    # Upstream download link was made unstable on purpose
    # See https://trac.filezilla-project.org/ticket/13186
    url = "https://sources.archlinux.org/other/packages/fzssh/fzssh-${finalAttrs.version}.tar.xz";
    hash = "sha256-Ionh58P8EdNyC2nua+5ASQwLPVvKIdfQYV38odgzeG0=";
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

  doCheck = true;

  passthru.updateScript = directoryListingUpdater { };

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
    maintainers = with lib.maintainers; [ iedame ];
    pkgConfigModules = [ "libfzssh-client" ];
  };
})
