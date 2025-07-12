{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  version = "0.94";
  pname = "pcg-c";

  src = fetchzip {
    url = "http://www.pcg-random.org/downloads/${pname}-${version}.zip";
    sha256 = "0smm811xbvs03a5nc2668zd0178wnyri2h023pqffy767bpy1vlv";
  };

  enableParallelBuilding = true;

  patches = [
    ./prefix-variable.patch
  ];

  preInstall = ''
    sed -i s,/usr/local,$out, Makefile
    mkdir -p $out/lib $out/include
  '';

  meta = {
    description = "Family of better random number generators";
    homepage = "https://www.pcg-random.org/";
    license = lib.licenses.asl20;
    longDescription = ''
      PCG is a family of simple fast space-efficient statistically good
      algorithms for random number generation. Unlike many general-purpose RNGs,
      they are also hard to predict.
    '';
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.linus ];
    broken = stdenv.hostPlatform.isi686; # https://github.com/imneme/pcg-c/issues/11
  };
}
