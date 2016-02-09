{ stdenv, fetchurl, pari ? null }:

let
  baseName = "gap";
  version = "4r4p12";

  pkgVer = "2012_01_12-10_47_UTC";
  pkgSrc = fetchurl {
    url = "ftp://ftp.gap-system.org/pub/gap/gap4/tar.bz2/packages-${pkgVer}.tar.bz2";
    sha256 = "0z9ncy1m5gvv4llkclxd1vpcgpb0b81a2pfmnhzvw8x708frhmnb";
  };
in

stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "ftp://ftp.gap-system.org/pub/gap/gap4/tar.gz/${baseName}${version}.tar.gz";
    sha256 = "0flap5lbkvpms3zznq1zwxyxyj0ax3fk7m24f3bvhvr37vyxnf40";
  };

  buildInputs = [ pari ];

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/gap/"

    cp -r . "$out/share/gap/build-dir"

    tar xf "${pkgSrc}" -C "$out/share/gap/build-dir/pkg"

    ${if pari != null then
      ''sed -e '2iexport PATH=$PATH:${pari}/bin' -i "$out/share/gap/build-dir/bin/gap.sh" ''
    else ""}
    sed -e "/GAP_DIR=/aGAP_DIR='$out/share/gap/build-dir/'" -i "$out/share/gap/build-dir/bin/gap.sh"

    ln -s "$out/share/gap/build-dir/bin/gap.sh" "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Computational discrete algebra system";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.gpl2;
    homepage = http://gap-system.org/;
    broken = true;
  };
}
