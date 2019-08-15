{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2.4.0";
  pname = "makeself";

  src = fetchFromGitHub {
    owner = "megastep";
    repo = "makeself";
    rev = "release-${version}";
    sha256 = "1lw3gx1zpzp2wmzrw5v7k31vfsrdzadqha9ni309fp07g8inrr9n";
  };

  # backported from https://github.com/megastep/makeself/commit/77156e28ff21231c400423facc7049d9c60fd1bd
  patches = [ ./Use-rm-from-PATH.patch ];

  postPatch = ''
    sed -e "s|^HEADER=.*|HEADER=$out/share/${pname}-${version}/makeself-header.sh|" -i makeself.sh
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/{${pname}-${version},man/man1}}
    cp makeself.lsm README.md $out/share/${pname}-${version}
    cp makeself.sh $out/bin/makeself
    cp makeself.1  $out/share/man/man1/
    cp makeself-header.sh $out/share/${pname}-${version}
  '';

  meta = with stdenv.lib; {
    homepage = http://megastep.org/makeself;
    description = "Utility to create self-extracting packages";
    license = licenses.gpl2;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
  };
}
