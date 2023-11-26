{ lib, stdenv, fetchFromGitHub, SDL_compat, libX11, libXext }:

stdenv.mkDerivation rec {
  pname = "rvvm";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "LekKit";
    repo = "RVVM";
    rev = "v${version}";
    sha256 = "sha256-1wAKijRYB0FGBe4cSHUynkO4ePVG4QvVIgSoWzNbqtE=";
  };

  buildInputs = if stdenv.isDarwin then [ SDL_compat ] else [ libX11 libXext ];

  buildFlags = [ "all" "lib" ];

  makeFlags = [ "PREFIX=$(out)" ]
    # work around https://github.com/NixOS/nixpkgs/issues/19098
    ++ lib.optional (stdenv.cc.isClang && stdenv.isDarwin) "CFLAGS=-fno-lto";

  meta = with lib; {
    homepage = "https://github.com/LekKit/RVVM";
    description = "The RISC-V Virtual Machine";
    license = with licenses; [ gpl3 /* or */ mpl20 ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];
  };
}
