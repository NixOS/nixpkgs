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
  version = "3.1.1";
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "n2n";
    rev = finalAttrs.version;
    hash = "sha256-/Yb6L6Pt2vR7fzVS1QS9Z46yaR26fqE7LPrAEHl5sbw=";
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

  env.PREFIX = placeholder "out";

  meta = {
    description = "Peer-to-peer VPN";
    homepage = "https://www.ntop.org/products/n2n/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ malte-v ];
  };
})
