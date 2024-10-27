{stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "rutorrent";
  version = "4.3.8";

  src = fetchFromGitHub {
    owner = "Novik";
    repo = "ruTorrent";
    rev = "v${version}";
    hash = "sha256-1JENw3JByrtzygSXov5Q0tTLrSzJnchYaS9SllXFOds=";
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
