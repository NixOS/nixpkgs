{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2.4.2";
  pname = "makeself";

  src = fetchFromGitHub {
    owner = "megastep";
    repo = "makeself";
    rev = "release-${version}";
    fetchSubmodules = true;
    sha256 = "07cq7q71bv3fwddkp2863ylry2ivds00f8sjy8npjpdbkailxm21";
  };

  patchPhase = "patchShebangs test";

  doCheck = true;
  checkTarget = "test";

  installPhase = ''
    mkdir -p $out/{bin,share/{${pname}-${version},man/man1}}
    cp makeself.lsm README.md $out/share/${pname}-${version}
    cp makeself.sh $out/bin/makeself
    cp makeself.1  $out/share/man/man1/
    cp makeself-header.sh $out/share/${pname}-${version}
  '';

  fixupPhase = ''
    sed -e "s|^HEADER=.*|HEADER=$out/share/${pname}-${version}/makeself-header.sh|" -i $out/bin/makeself
  '';

  meta = with stdenv.lib; {
    homepage = "http://megastep.org/makeself";
    description = "Utility to create self-extracting packages";
    license = licenses.gpl2;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
  };
}
