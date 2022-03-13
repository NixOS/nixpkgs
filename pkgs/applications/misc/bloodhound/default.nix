{ lib
, stdenv
, fetchurl
, makeWrapper
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gnome2
, gtk3
, libGL
, libappindicator-gtk3
, libdrm
, libnotify
, libpulseaudio
, libuuid
, libxcb
, libxkbcommon
, libxshmfence
, mesa
, nspr
, nss
, pango
, systemd
, unzip
, xdg-utils
, xorg
}:
stdenv.mkDerivation rec {
  pname = "bloodhound";
  binaryName = "BloodHound";
  version = "4.1.0";
  src = fetchurl {
    url = "https://github.com/BloodHoundAD/BloodHound/releases/download/${version}/BloodHound-linux-x64.zip";
    sha256 = "sha256-Sxll+yjFCv9jK65R4r/uFTAJeX8rV2kyB200cvmErmY=";
  };

  rpath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk3
    libGL
    libappindicator-gtk3
    libdrm
    libnotify
    libpulseaudio
    libuuid
    libxcb
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxkbfile
    xorg.libxshmfence
  ] + ":${stdenv.cc.cc.lib}/lib64";

  buildInputs = [
    gtk3 # needed for GSETTINGS_SCHEMAS_PATH
  ];

  nativeBuildInputs = [ makeWrapper unzip ];

  dontUnpack = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    unzip $src
    mkdir -p $out
    mkdir -p $out/{bin,lib/${binaryName}}
    mv BloodHound-linux-x64/* $out/lib/${binaryName}
    chmod +x $out/lib/${binaryName}/${binaryName}

    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
       $out/lib/${binaryName}/${binaryName}

    makeWrapper $out/lib/${binaryName}/${binaryName} $out/bin/${binaryName} \
      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
      --prefix PATH : ${lib.makeBinPath [xdg-utils]} \
      --prefix LD_LIBRARY_PATH : ${rpath}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Six Degrees of Domain Admin";
    homepage = "https://github.com/BloodHoundAD/BloodHound";
    downloadPage = "https://github.com/BloodHoundAD/BloodHound/release";
    license = licenses.gpl3;
    maintainers = with maintainers; [ lyrain ];
    platforms = [ "x86_64-linux" ];
  };
}
