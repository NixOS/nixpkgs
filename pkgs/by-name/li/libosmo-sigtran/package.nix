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

stdenv.mkDerivation rec {
  pname = "libosmo-sigtran";
  version = "2.1.0";

  # fetchFromGitea hangs
  src = fetchgit {
    url = "https://gitea.osmocom.org/osmocom/libosmo-sigtran.git";
    rev = version;
    hash = "sha256-/MUFTo5Uo60CZV0ZTDVLVgEXrNw9kX5gafq7rJb82Do=";
  };

  configureFlags = [ "--with-systemdsystemunitdir=$out" ];

  postPatch = ''
    echo "${version}" > .tarball-version
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

  meta = with lib; {
    description = "SCCP + SIGTRAN (SUA/M3UA) libraries as well as OsmoSTP";
    mainProgram = "osmo-stp";
    homepage = "https://osmocom.org/projects/libosmo-sccp";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      markuskowa
    ];
  };
}
