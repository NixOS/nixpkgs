{ lib
, stdenv
, requireFile
, autoPatchelfHook
, makeWrapper
, dpkg
, alsaLib
, eudev
, gnome
, libglvnd
, krb5
, mono
, pulseaudio
, xorg
}:

stdenv.mkDerivation rec {
  pname = "dungeondraft";
  version = "1.1.0.6";

  src = requireFile {
    name = "Dungeondraft-${version}-Linux64.deb";
    url = "https://dungeondraft.net/";
    hash = "sha256-ffT2zOQWKb6W6dQGuKbfejNCl6dondo4CB6JKTReVDs=";
  };
  sourceRoot = ".";
  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  dontConfigure = true;
  dontBuild = true;
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    alsaLib
    eudev
    gnome.zenity
    libglvnd
    krb5
    pulseaudio
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -R usr/share opt $out/
    substituteInPlace \
      $out/share/applications/Dungeondraft.desktop \
      --replace /opt/ $out/opt/
    ln -s $out/opt/Dungeondraft/Dungeondraft.x86_64 $out/bin/${meta.mainProgram}
    rm -rf $out/opt/Dungeondraft/data_Dungeondraft/Mono/
    ln -s ${mono.out} $out/opt/Dungeondraft/data_Dungeondraft/Mono
    runHook postInstall
  '';


  ldpath = lib.makeLibraryPath buildInputs
    + lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")
      (":" + lib.makeSearchPathOutput "lib" "lib64" buildInputs);
  path = lib.makeBinPath buildInputs;
  postFixup = "wrapProgram $out/bin/${meta.mainProgram} --set LD_LIBRARY_PATH ${ldpath} --set PATH ${path}";

  meta = with lib; {
    homepage = "https://dungeondraft.net/";
    description = "A mapmaking tool for Tabletop Roleplaying Games, designed for dungeon scale";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ chysi ];
    mainProgram = "Dungeondraft.x86_64";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
