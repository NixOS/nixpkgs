{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "rutorrent";
  version = "3.10";

  src = fetchFromGitHub {
    owner = "Novik";
    repo = "ruTorrent";
    rev = "v${version}";
    sha256 = "1gnqbvyax8w84frx60adm58ixh6nycpm24lqmqa996sy6fpknmg4";
  };

  installPhase = ''
    mkdir -p $out/
    cp -r . $out/
  '';

  meta = with stdenv.lib; {
    description = "Yet another web front-end for rTorrent";
    homepage = "https://github.com/Novik/ruTorrent";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
