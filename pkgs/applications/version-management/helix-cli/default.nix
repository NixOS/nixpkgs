{ stdenv, fetchurl, patchelf }:

stdenv.mkDerivation rec {
  name = "helix-cli-${version}";
  version = "2018.1.1705517";

  src = fetchurl {
    url = "https://cdist2.perforce.com/perforce/r18.1/bin.linux26x86_64/p4";
    sha256 = "770c38fbd3726bd11abfd450900d492b41b5bd6049703a063fca20d1a70ecdc6";
  };

  dontBuild = true;
  phases = [ "installPhase" ];

  installPhase = ''
    install -D -m755 $src $out/bin/p4

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $libPath \
      $out/bin/p4
  '';

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.libc ];

  meta = with stdenv.lib; {
    description = "Helix Command-Line Client (p4)";
    homepage = https://www.perforce.com;
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.nathyong ];
  };
}

