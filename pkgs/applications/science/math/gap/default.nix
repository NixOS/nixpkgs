{ stdenv, fetchurl, m4, gmp }:

let
  baseName = "gap";
  version = "4r8p3";

  pkgVer = "2016_03_19-22_17";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "ftp://ftp.gap-system.org/pub/gap/gap48/tar.gz/${baseName}${version}_${pkgVer}.tar.gz";
    sha256 = "1rmb0lj43avv456sjwb7ia3y0wwk5shlqylpkdwnnqpjnvjbnzv6";
  };

  configureFlags = [ "--with-gmp=system" ];
  buildInputs = [ m4 gmp ];
  
  postBuild = ''
    pushd pkg
    bash ../bin/BuildPackages.sh
    popd
  '';
  
  installPhase = ''
    mkdir -p "$out/bin" "$out/share/gap/"

    cp -r . "$out/share/gap/build-dir"

    sed -e "/GAP_DIR=/aGAP_DIR='$out/share/gap/build-dir/'" -i "$out/share/gap/build-dir/bin/gap.sh"

    ln -s "$out/share/gap/build-dir/bin/gap.sh" "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Computational discrete algebra system";
    maintainers = with maintainers;
    [
      raskin
      chrisjefferson
    ];
    platforms = platforms.all;
    license = licenses.gpl2;
    homepage = http://gap-system.org/;
  };
}
