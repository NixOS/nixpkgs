{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "p4";
  version = "2019.2.1915892";

  src = fetchurl {
    url = "https://cdist2.perforce.com/perforce/r19.2/bin.linux26x86_64/helix-core-server.tgz";
    sha256 = "42ff4c630722910f09e93eeb9ed948f4e02171e3e3ea72bd15f944ffef7e7a34";
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  dontBuild = true;

  ldLibraryPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r p* $out/bin/

    for f in $out/bin/* ; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f
    done
  '';

  meta = {
    description = "Perforce Command-Line Client";
    homepage = https://www.perforce.com;
    license = stdenv.lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ nathyong nioncode ];
  };
}
