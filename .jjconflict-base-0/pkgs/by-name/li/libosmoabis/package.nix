{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  libosmocore,
  libosmo-netif,
  ortp,
  bctoolbox,
}:

stdenv.mkDerivation rec {
  pname = "libosmoabis";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmo-abis";
    rev = version;
    hash = "sha256-TxK+r+GhqPjvFYA3AX3JXjRwhEyjoLcPTR1lpkgSlUo=";
  };

  configureFlags = [ "enable_dahdi=false" ];

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    libosmo-netif
    ortp
    bctoolbox
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Osmocom Abis interface library";
    homepage = "https://github.com/osmocom/libosmo-abis";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      markuskowa
    ];
  };
}
