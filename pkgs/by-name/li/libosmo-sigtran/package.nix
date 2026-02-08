{
  lib,
  stdenv,
  autoreconfHook,
  fetchgit,
  lksctp-tools,
  pkg-config,
  libosmocore,
  libosmo-netif,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libosmo-sigtran";
  version = "2.1.2";

  # fetchFromGitea hangs
  src = fetchgit {
    url = "https://gitea.osmocom.org/osmocom/libosmo-sigtran.git";
    rev = finalAttrs.version;
    hash = "sha256-/TxD7lc/htm1c24rKfnlYxGsVpxawi3nh7m34mRRhUA=";
  };

  configureFlags = [ "--with-systemdsystemunitdir=$out" ];

  postPatch = ''
    echo "${finalAttrs.version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    lksctp-tools
    libosmocore
    libosmo-netif
  ];

  enableParallelBuilding = true;

  meta = {
    description = "SCCP + SIGTRAN (SUA/M3UA) libraries as well as OsmoSTP";
    mainProgram = "osmo-stp";
    homepage = "https://osmocom.org/projects/libosmo-sccp";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      markuskowa
    ];
  };
})
