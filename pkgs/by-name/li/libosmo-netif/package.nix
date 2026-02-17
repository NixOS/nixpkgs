{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  lksctp-tools,
  pkg-config,
  libosmocore,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libosmo-netif";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmo-netif";
    rev = finalAttrs.version;
    hash = "sha256-0INgJV5fS6VdMsJqjlVc3lGMBdLP7cI+Ghc4WEh6AuU=";
  };

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
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom network / socket interface library";
    homepage = "https://osmocom.org/projects/libosmo-netif/wiki";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      markuskowa
    ];
  };
})
