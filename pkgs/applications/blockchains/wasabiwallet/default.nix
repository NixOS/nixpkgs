{ lib, stdenv
, fetchurl
, makeDesktopItem
, curl
, dotnetCorePackages
, fontconfig
, krb5
, openssl
, xorg
, zlib
, libICE
, libSM
}:

let
  dotnet-runtime = dotnetCorePackages.runtime_5_0;
  libPath = lib.makeLibraryPath [
    curl
    dotnet-runtime
    fontconfig.lib
    krb5
    openssl
    stdenv.cc.cc.lib
    xorg.libX11
    zlib
    libICE
    libSM
  ];
in
stdenv.mkDerivation rec {
  pname = "wasabiwallet";
  version = "2.0.2";

  src = fetchurl {
    url = "https://github.com/zkSNACKs/WalletWasabi/releases/download/v${version}/Wasabi-${version}.tar.gz";
    sha256 = "sha256-0DFl+UFxQckRM2qXFqDpKaRQ5sIMUbNj7l3zKPKAOnQ=";
  };

  dontBuild = true;
  dontPatchELF = true;

  desktopItem = makeDesktopItem {
    name = "wasabi";
    exec = "wasabiwallet";
    desktopName = "Wasabi";
    genericName = "Bitcoin wallet";
    comment = meta.description;
    categories = [ "Network" "Utility" ];
  };

  installPhase = ''
    mkdir -p $out/opt/${pname} $out/bin $out/share/applications
    cp -Rv . $out/opt/${pname}
    cd $out/opt/${pname}
    BINARIES="wassabee \
              Microservices/Binaries/lin64/Tor/tor \
              Microservices/Binaries/lin64/bitcoind \
              Microservices/Binaries/lin64/hwi"
    for i in $(find . -type f -name '*.so') $BINARIES
      do
        patchelf --set-rpath ${libPath} $i
      done
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $BINARIES
    ln -s $out/opt/${pname}/wassabee $out/bin/${pname}
    cp -v $desktopItem/share/applications/* $out/share/applications
  '';

  meta = with lib; {
    description = "Privacy focused Bitcoin wallet";
    homepage = "https://wasabiwallet.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mmahut ];
  };
}
