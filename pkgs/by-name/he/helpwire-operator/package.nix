{
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  xorg,
  libgcc,
  libGLU,
  glib,
  libXinerama,
  libxkbcommon,
  wayland,
  freetype,
  fontconfig,
  lib,
}:
stdenv.mkDerivation rec {
  name = "helpwire-operator";
  pname = name;
  version = "2.1.6.127";
  meta = with lib; {
    description = "A remote desktop access app to be used with the HelpWire web app.";
    homepage = "https://helpwire.app";
    license = licenses.unfreeRedistributable;
    mainProgram = "helpwire-operator";
    platforms = platforms.unix;
    inherit version;
  };
  src = fetchurl {
    url = "https://www.helpwire.app/downloads/operator/linux/helpwire-operator.deb";
    sha256 = "04zkz90k279w8y1k0d4lz9xywjf0k2bccyj7l5rpaq53mvwvx6l8";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];
  buildInputs = [
    xorg.libX11
    stdenv.cc.cc.lib
    libgcc
    xorg.libXfixes
    xorg.libXtst
    libGLU
    glib
    libXinerama
    libxkbcommon
    wayland
    freetype
    fontconfig
  ];
  unpackPhase = "dpkg-deb -x $src .";
  postUnpack = ''
    patchelf --ignore-missing libpng16.so.16 $sourceRoot/opt/HelpWire/Operator/lib/libQt5Gui.so.5
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share

    mv usr/share/doc $out/share/doc
    mv etc $out/etc
    mv opt $out/opt
    ln -s $out/opt/HelpWire/Operator/bin $out/bin

    runHook postInstall
  '';
}
