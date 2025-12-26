{
  ### Tools
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  dpkg,
  gnutar,

  ### Libs
  xorg,
  libxkbcommon,
  glib,
  nss,
  dbus,
  at-spi2-atk,
  cups,
  gtk3,
  pango,
  cairo,
  expat,
  systemdLibs,
  alsa-lib,
  nwjs,
  libGL,
}:

stdenvNoCC.mkDerivation rec {
  pname = "deezer-enhanced";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/duzda/deezer-enhanced/releases/download/v${version}/deezer-enhanced_${version}_amd64.deb";
    hash = "sha256-n7/yEzr40ApBzE+kLWehgMHwkoom4QT9fYLSuFqVA7s=";
  };

  nativeBuildInputs = [
    ### To unpack deezer-enhanced
    dpkg
    gnutar

    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [

    ### Xorg libs
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb

    ### Systemd libs
    systemdLibs
    dbus

    ### Other libs
    libxkbcommon
    nss
    glib
    at-spi2-atk
    cups
    gtk3
    libGL
    nwjs # For libffmpeg.so
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb --fsys-tarfile $src | tar --no-same-owner --no-same-permissions -xvf -

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    ### Create directory and copy files
    mkdir -p $out
    mv usr/* $out

    ### Wrap deezer-enhanced to include all libraries in the environment
    wrapProgram $out/bin/${pname} \
      --set LD_LIBRARY_PATH ${
        lib.makeLibraryPath [
          ### Xorg libs
          xorg.libX11
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          xorg.libxcb

          ### Systemd libs
          systemdLibs
          dbus

          ### Other libs
          libxkbcommon
          nss
          glib
          at-spi2-atk
          cups
          gtk3
          nwjs
          libGL
        ]
      }

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/duzda/deezer-enhanced";
    changelog = "https://github.com/duzda/deezer-enhanced/releases/tag/v${version}";
    description = "Unofficial application for Deezer with enhanced features";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "deezer-enhanced";
    maintainers = with lib.maintainers; [ minegameYTB ];
  };
}
