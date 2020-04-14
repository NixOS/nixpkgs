{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "rutorrent";
  version = "3.10-beta";

  src = fetchFromGitHub {
    owner = "Novik";
    repo = "ruTorrent";
    rev = "v${version}";
    sha256 = "0qim3g6xfl9hdyhg6nfyzn594p5b3wbcdzmifdmfpj4kfngwjv1v";
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
