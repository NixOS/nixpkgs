{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  libosmocore,
  libosmo-netif,
  linphonePackages,
}:

stdenv.mkDerivation rec {
  pname = "libosmoabis";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmo-abis";
    rev = version;
    hash = "sha256-OdmegQXdbpwNBepY+7MeUjaEguVo2q9b8lSkRmlXHEc=";
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
    linphonePackages.ortp
    linphonePackages.bctoolbox
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
