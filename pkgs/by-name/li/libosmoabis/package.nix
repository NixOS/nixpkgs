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

stdenv.mkDerivation (finalAttrs: {
  pname = "libosmoabis";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmo-abis";
    rev = finalAttrs.version;
    hash = "sha256-VIUEP0fOfahGq0jCJWRiaBYd+rZRSFqjyR0i7a0Rvg0=";
  };

  configureFlags = [ "enable_dahdi=false" ];

  postPatch = ''
    echo "${finalAttrs.version}" > .tarball-version
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

  meta = {
    description = "Osmocom Abis interface library";
    homepage = "https://github.com/osmocom/libosmo-abis";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      markuskowa
    ];
  };
})
