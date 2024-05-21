{ lib, trivialBuild, fetchurl, haskell-mode }:

trivialBuild rec {
  pname = "hsc3-mode";
  version = "0.15";

  src = fetchurl {
    url = "mirror://hackage/hsc3-${version}/hsc3-${version}.tar.gz";
    sha256 = "2f3b15655419cf8ebe25ab1c6ec22993b2589b4ffca7c3a75ce478ca78a0bde6";
  };

  packageRequires = [ haskell-mode ];

  sourceRoot = "hsc3-${version}/emacs";

  meta = {
    homepage = "http://rd.slavepianos.org/?t=hsc3";
    description = "hsc3 mode package for Emacs";
    platforms = lib.platforms.unix;
  };
}
