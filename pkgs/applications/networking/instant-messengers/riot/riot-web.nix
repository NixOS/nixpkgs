{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name= "riot-web-${version}";
  version = "0.13.1";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "19g0d3wqmz4vj9flf7pfgfvm2qf2w3jhxp9qdyfbiwd670h5wjlv";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = {
    description = "A glossy Matrix collaboration client for the web";
    homepage = http://riot.im/;
    maintainers = with stdenv.lib.maintainers; [ bachp ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
