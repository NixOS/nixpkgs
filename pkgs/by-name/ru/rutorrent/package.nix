{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "rutorrent";
  version = "4.2.10";

  src = fetchFromGitHub {
    owner = "Novik";
    repo = "ruTorrent";
    rev = "v${version}";
    hash = "sha256-Hkh2fWaZpJLxUYaojR97XVQWXTRzmFkQe4xKsmY1E8M=";
  };

  installPhase = ''
    mkdir -p $out/
    cp -r . $out/
  '';

  meta = with lib; {
    description = "Yet another web front-end for rTorrent";
    homepage = "https://github.com/Novik/ruTorrent";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
