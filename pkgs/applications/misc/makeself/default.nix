{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "makeself-2.1.5";
  src = fetchurl {
    url = "http://megastep.org/makeself/makeself.run";
    sha256 = "0khs19xpid4ng0igrjyz3vsi6a5xyixrrrhgdxpdhd2wnf5nc9w2";
  };
  unpackPhase = "sh ${src}";
  installPhase = ''
    cd ${name}
    mkdir -p $out/{bin,share/{${name},man/man1}}
    mv makeself.lsm README $out/share/${name}
    mv makeself.sh $out/bin/makeself
    mv makeself.1  $out/share/man/man1/
    mv makeself-header.sh $out/share/${name}
    sed -e 's|HEADER=`dirname $0`/makeself-header.sh|HEADER=`dirname $0`/../share/${name}/makeself-header.sh|' -i $out/bin/makeself
  '';
  meta = {
    homepage = http://megastep.org/makeself;
    description = "Utility to create self-extracting packages";
  };
}
