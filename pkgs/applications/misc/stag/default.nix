{ stdenv, fetchgit, curses }:

stdenv.mkDerivation {
  name = "stag-1.0";

  src = fetchgit {
    url = https://github.com/seenaburns/stag.git;
    rev = "90e2964959ea8242349250640d24cee3d1966ad6";
    sha256 = "88628dfa07a0772c7eca0cc66ef2d8f3e20297deec021c776a82fe1323bafb0f";
  };

  buildInputs = [ stdenv curses ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    homepage = "https://github.com/seenaburns/stag";
    description = "Terminal streaming bar graph passed through stdin";
    license = stdenv.lib.licenses.bsdOriginal;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
  };
}
