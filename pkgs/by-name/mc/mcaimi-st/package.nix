{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  libX11,
  libXext,
  libXft,
  ncurses,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "mcaimi-st";
  version = "0-unstable-2025-03-12";

  src = fetchFromGitHub {
    owner = "mcaimi";
    repo = "st";
    rev = "f1ae5cdafadceaf622e1c0ff56da04803bf658b3";
    hash = "sha256-rGru0LqbuJQ4QOts6xYDztAST0K5HCys2gUPZg2w4SE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    fontconfig
    libX11
    libXext
    libXft
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
    homepage = "https://github.com/mcaimi/st";
    description = "Suckless Terminal fork";
    mainProgram = "st";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
