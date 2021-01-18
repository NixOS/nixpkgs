{ lib, stdenv
, fetchurl
, makeDesktopItem
, curl
, dotnet-netcore
, fontconfig
, krb5
, openssl
, xorg
, zlib
}:

let
  libPath = lib.makeLibraryPath [
    curl
    dotnet-netcore
    fontconfig.lib
    krb5
    openssl
    stdenv.cc.cc.lib
    xorg.libX11
    zlib
  ];
in
stdenv.mkDerivation rec {
  pname = "wasabiwallet";
  version = "1.1.12.3";

  src = fetchurl {
    url = "https://github.com/zkSNACKs/WalletWasabi/releases/download/v${version}/Wasabi-${version}.tar.gz";
    sha256 = "1x4gqmiwdp5bjq7c5hjch3srsvf73d92lswnp355l7l7cxh2hcsx";
  };

  dontBuild = true;
  dontPatchELF = true;

  desktopItem = makeDesktopItem {
    name = "wasabi";
    exec = "wasabiwallet";
    desktopName = "Wasabi";
    genericName = "Bitcoin wallet";
    comment = meta.description;
    categories = "Network;Utility;";
  };

  installPhase = ''
    mkdir -p $out/opt/${pname} $out/bin $out/share/applications
    cp -Rv . $out/opt/${pname}
    cd $out/opt/${pname}
    for i in $(find . -type f -name '*.so') wassabee
      do
        patchelf --set-rpath ${libPath} $i
      done
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" wassabee
    ln -s $out/opt/${pname}/wassabee $out/bin/${pname}
    cp -v $desktopItem/share/applications/* $out/share/applications
  '';

  meta = with lib; {
    description = "Privacy focused Bitcoin wallet";
    homepage = "https://wasabiwallet.io/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mmahut ];
  };
}
