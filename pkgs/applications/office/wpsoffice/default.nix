{ stdenv, fetchurl, fetchFromGitHub
, libX11, glib, xorg, fontconfig, freetype
, zlib, libpng12, libICE, libXrender, cups }:

let
  bits = if stdenv.system == "x86_64-linux" then "x86_64"
         else "x86";

  version = "10.1.0.5672";
in stdenv.mkDerivation rec{
  name = "wpsoffice-${version}";

  src = fetchurl {
    name = "${name}.tar.xz";
    url = "http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_${version}~a21_${bits}.tar.xz";
    sha256 = if bits == "x86_64" then
      "0mi3n9kplf82gd0g2m0np957agy53p4g1qh81pbban49r4n0ajcz" else
      "1dk400ap5qwdhjvn8lnk602f5akayr391fkljxdkrpn5xac01m97";
  };
  
  meta = {
    description = "Office program originally named Kingsoft Office";
    homepage = http://wps-community.org/;
    platforms = [ "i686-linux" "x86_64-linux" ];
    hydraPlatforms = [];
    license = stdenv.lib.licenses.unfreeRedistributable;
  };

  libPath = stdenv.lib.makeLibraryPath [
    libX11
    libpng12
    glib
    xorg.libSM
    xorg.libXext
    fontconfig
    zlib
    freetype
    libICE
    cups
    libXrender
  ];

  dontPatchELF = true;

  installPhase = ''
    prefix=$out/opt/kingsoft/wps-office
    mkdir -p $prefix
    cp -r . $prefix

    # Avoid forbidden reference error due use of patchelf
    rm -r $PWD

    mkdir $out/bin
    for i in wps wpp et; do
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --force-rpath --set-rpath "$prefix/office6:$libPath" \
        $prefix/office6/$i

      substitute $prefix/$i $out/bin/$i \
        --replace /opt/kingsoft/wps-office $prefix
      chmod +x $out/bin/$i

      substituteInPlace $prefix/resource/applications/wps-office-$i.desktop \
        --replace /usr/bin $out/bin
    done

    # China fonts
    mkdir -p $prefix/resource/fonts/wps-office $out/etc/fonts/conf.d
    ln -s $prefix/fonts/* $prefix/resource/fonts/wps-office
    ln -s $prefix/fontconfig/*.conf $out/etc/fonts/conf.d

    ln -s $prefix/resource $out/share
  '';
}
