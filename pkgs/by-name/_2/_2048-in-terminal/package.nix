{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "2048-in-terminal";
  version = "0-unstable-2022-06-13";

  src = fetchFromGitHub {
    owner = "alewmoose";
    repo = "2048-in-terminal";
    rev = "bf22f868a2e0e572f22153468585ec0226a4b8b2";
    sha256 = "sha256-Y5ZQYWOiG3QZZsr+d7olUDGAQ1LhRG9X2hBNQDx+Ztw=";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/bin
  '';
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    inherit (src.meta) homepage;
    description = "Animated console version of the 2048 game";
    mainProgram = "2048-in-terminal";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
