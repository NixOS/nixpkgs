{ stdenv, fetchurl, autoPatchelfHook, makeWrapper, wrapGAppsHook,
  curl, dotnet-netcore, dpkg, fontconfig, gcc, gsettings-desktop-schemas, gtk3, lttng-ust, openssl, xorg }:

stdenv.mkDerivation rec {
  pname = "alttpr-opentracker";
  version = "1.6.1";
  src = fetchurl {
    url = "https://github.com/trippsc2/OpenTracker/releases/download/${version}/OpenTracker.${version}.debian-x64.deb";
    sha256 = "159c9k5nd4iq7c8f7bqmj3373w24bchayfyq9blsmx68349ls8x8";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    curl
    dotnet-netcore
    dpkg
    fontconfig
    gcc
    gsettings-desktop-schemas
    gtk3
    lttng-ust
    makeWrapper
    openssl
    wrapGAppsHook
  ];

  ld_path = stdenv.lib.makeLibraryPath [
    gtk3
    openssl
    xorg.libX11
    xorg.libXi
    xorg.xinput
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    dpkg --fsys-tarfile $src | tar --extract

    mkdir -p $out/bin
    mv usr/* $out
    rm -r $out/local

    chmod -R g-w $out

    makeWrapper $out/share/OpenTracker/OpenTracker $out/bin/OpenTracker \
      --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1 \
      --prefix LD_LIBRARY_PATH : ${ld_path}
  '';

  meta = with stdenv.lib; {
    description = "An open-source cross-platform tracking app for A Link to the Past Randomizer";
    homepage = "https://github.com/trippsc2/OpenTracker";
    downloadPage = "https://github.com/trippsc2/OpenTracker/releases";
    maintainers = with maintainers; [ islandusurper ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
