{ stdenv, fetchurl, python, rcs, git, makeWrapper }:

stdenv.mkDerivation rec {
  name = "src-${version}";
  version = "1.12";

  src = fetchurl {
    url = "http://www.catb.org/~esr/src/${name}.tar.gz";
    sha256 = "1m6rjbizx9win3jkciyx176sfy98r5arb1g3l6aqnqam9gpr44zm";
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
