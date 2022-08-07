{ stdenv, lib, fetchFromGitHub, makeWrapper
, xwininfo, xdotool, xprop, gawk, coreutils
, gnugrep, procps }:

stdenv.mkDerivation rec {
  pname = "tdrop";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "tdrop";
    rev = version;
    sha256 = "sha256-1umHwzpv4J8rZ0c0q+2dPsEk4vhFB4UerwI8ctIJUZg=";
  };

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = let
    binPath = lib.makeBinPath [
      xwininfo
      xdotool
      xprop
      gawk
      coreutils
      gnugrep
      procps
    ];
  in ''
    wrapProgram $out/bin/tdrop --prefix PATH : ${binPath}
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "A Glorified WM-Independent Dropdown Creator";
    homepage = "https://github.com/noctuid/tdrop";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
