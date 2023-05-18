{ lib, stdenv, fetchFromGitHub, curses }:

stdenv.mkDerivation {
  pname = "stag";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "seenaburns";
    repo = "stag";
    rev = "90e2964959ea8242349250640d24cee3d1966ad6";
    sha256 = "1yrzjhcwrxrxq5jj695wvpgb0pz047m88yq5n5ymkcw5qr78fy1v";
  };

  buildInputs = [ curses ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://github.com/seenaburns/stag";
    description = "Terminal streaming bar graph passed through stdin";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
  };
}
