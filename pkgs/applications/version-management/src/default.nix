{ stdenv, fetchurl, python, rcs, git, makeWrapper }:

stdenv.mkDerivation rec {
  name = "src-${version}";
  version = "1.13";

  src = fetchurl {
    url = "http://www.catb.org/~esr/src/${name}.tar.gz";
    sha256 = "0l13ld8nxm1c720ns22lyx3q1bq2c2zn78vi5w92b7nl6p2nncy8";
  };

  buildInputs = [ python rcs git makeWrapper ];

  preConfigure = ''
    patchShebangs .
  '';

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/src \
      --suffix PATH ":" "${rcs}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Simple single-file revision control";
    homepage = http://www.catb.org/~esr/src/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ calvertvl ];
  };
}
