{
  lib,
  stdenv,
  fetchFromCodeberg,
  fontconfig,
  libx11,
  libxext,
  libxft,
  ncurses,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "mcaimi-st";
  version = "0.9.3-unstable-2025-09-22";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "mcaimi";
    repo = "st";
    rev = "667ded8e13457b0ba9d84b98545885e5a3e9dcc7";
    hash = "sha256-LbMxZhNs0sfgTm0R+BqxZpUPjs0Y3a2H40BYdMzO2CU=";
  };

  nativeBuildInputs = [
    pkg-config
    ncurses
  ];

  buildInputs = [
    fontconfig
    libx11
    libxext
    libxft
    ncurses
  ];

  installFlags = [
    "TERMINFO=$(out)/share/terminfo"
    "PREFIX=$(out)"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://codeberg.org/mcaimi/st";
    description = "Suckless Terminal fork";
    mainProgram = "st";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
