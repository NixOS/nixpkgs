{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n2n";
  version = "3.0";
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "n2n";
    rev = finalAttrs.version;
    hash = "sha256-OXmcc6r+fTHs/tDNF3akSsynB/bVRKB6Fl5oYxmu+E0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libcap
  ];

  postPatch = ''
    patchShebangs autogen.sh
  '';

  preAutoreconf = ''
    ./autogen.sh
  '';

  PREFIX = placeholder "out";

  meta = {
    description = "Peer-to-peer VPN";
    homepage = "https://www.ntop.org/products/n2n/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ malte-v ];
  };
})
