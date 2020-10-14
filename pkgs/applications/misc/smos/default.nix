{ stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  name = "smos-${version}";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/NorfairKing/smos/releases/download/v${version}/smos-release.zip";
    sha256 = "sha256:07yavk7xl92yjwwjdig90yq421n8ldv4fjfw7izd4hfpzw849a12";
  };

  phases = [ "unpackPhase" ];
  unpackCmd = "${unzip}/bin/unzip -d $out $curSrc";
  sourceRoot = ".";

  meta = with stdenv.lib; {
    description = "A comprehensive self-management system";
    homepage = https://smos.online;
    license = licenses.mit;
    maintainers = with maintainers; [ norfair ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
