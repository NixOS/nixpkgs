{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  libosmoabis,
  sqlite,
}:

let
  inherit (stdenv.hostPlatform) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-hlr";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-hlr";
    rev = version;
    hash = "sha256-c8dnDXZ5K8hjHWq/AjsPFJlamuuasz7mQS5iIBjWCG0=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    libosmoabis
    sqlite
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom implementation of 3GPP Home Location Registr (HLR)";
    homepage = "https://osmocom.org/projects/osmo-hlr";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "osmo-hlr";
  };
}
