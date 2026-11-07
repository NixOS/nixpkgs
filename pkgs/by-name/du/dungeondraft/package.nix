{
  lib,
  stdenv,
  requireFile,
  dpkg,
  xorg,
  libGL,
  udev,
  pulseaudio,
  libkrb5,
  zenity,
  zlib,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dungeondraft";
  version = "1.1.0.6";

  nativeBuildInputs = [ makeWrapper ];

  src = requireFile {
    name = "Dungeondraft-${finalAttrs.version}-Linux64.deb";
    url = "https://dungeondraft.net/";
    hash = "sha256-ffT2zOQWKb6W6dQGuKbfejNCl6dondo4CB6JKTReVDs=";
  };
  sourceRoot = ".";
  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -R usr/share opt $out/
    substituteInPlace \
      $out/share/applications/Dungeondraft.desktop \
      --replace /opt/ $out/opt/
    ln -s $out/opt/Dungeondraft/Dungeondraft.x86_64 $out/bin/Dungeondraft.x86_64
    runHook postInstall
  '';
  preFixup =
    let
      binaryLibPath = lib.makeLibraryPath [
        xorg.libXcursor
        xorg.libXinerama
        xorg.libXext
        xorg.libXrandr
        xorg.libXrender
        xorg.libX11
        xorg.libXi
        libGL
        udev
        pulseaudio
        zenity
      ];
      libmonoNativeLibPath = lib.makeLibraryPath [ libkrb5 ];
      libmonoPosixHelperLibPath = lib.makeLibraryPath [ zlib ];
    in
    ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${binaryLibPath}" \
        $out/opt/Dungeondraft/Dungeondraft.x86_64

      chmod +x \
        $out/opt/Dungeondraft/data_Dungeondraft/Mono/lib/*

      patchelf \
        --set-rpath "${libmonoNativeLibPath}" \
        $out/opt/Dungeondraft/data_Dungeondraft/Mono/lib/libmono-native.so

      patchelf \
        --set-rpath "${libmonoPosixHelperLibPath}" \
        $out/opt/Dungeondraft/data_Dungeondraft/Mono/lib/libMonoPosixHelper.so
    '';
  postInstall = ''
    wrapProgram $out/bin/Dungeondraft.x86_64 \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = {
    homepage = "https://dungeondraft.net/";
    description = "A mapmaking tool for Tabletop Roleplaying Games, designed for battlemap scale";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ jsusk ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
