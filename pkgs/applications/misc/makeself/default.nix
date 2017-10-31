{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2.3.1";
  name = "makeself-${version}";

  src = fetchFromGitHub {
    owner = "megastep";
    repo = "makeself";
    rev = "release-${version}";
    sha256 = "01r7vb9vyb99s3g5cw0c04s1ahcingynk3ki17wknlk2asjrbc4p";
  };

  patchPhase = ''
    sed -e "s|^HEADER=.*|HEADER=$out/share/${name}/makeself-header.sh|" -i makeself.sh
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/{${name},man/man1}}
    cp makeself.lsm README.md $out/share/${name}
    cp makeself.sh $out/bin/makeself
    cp makeself.1  $out/share/man/man1/
    cp makeself-header.sh $out/share/${name}
  '';

  meta = with stdenv.lib; {
    homepage = http://megastep.org/makeself;
    description = "Utility to create self-extracting packages";
    license = licenses.gpl2;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
  };
}
