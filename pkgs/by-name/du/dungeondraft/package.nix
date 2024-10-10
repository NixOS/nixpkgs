{ lib
, stdenv
, requireFile
, dpkg
, xorg
, libGL
, udev
, pulseaudio
, libkrb5
, zlib
, makeWrapper
, gnome
}:

stdenv.mkDerivation rec {
  pname = "dungeondraft";
  version = "1.1.0.3";

  nativeBuildInputs = [ makeWrapper ];

  src = requireFile {
    name = "Dungeondraft-${version}-Linux64.deb";
    url = "https://dungeondraft.net/";
    hash = "sha256-rvBhmAXotx6o9K8DM9ucyVIDMVGn3N50ag7jQ+I/VSE=";
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
  preFixup = let
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
      gnome.zenity
    ];
    libmonoNativeLibPath = lib.makeLibraryPath [ libkrb5 ];
    libmonoPosixHelperLibPath = lib.makeLibraryPath [ zlib ];
  in ''
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
      --prefix PATH : ${lib.makeBinPath [ gnome.zenity ]}
    '';

  meta = with lib; {
    homepage = "https://dungeondraft.net/";
    description = "A mapmaking tool for Tabletop Roleplaying Games, designed for battlemap scale";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jsusk ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
