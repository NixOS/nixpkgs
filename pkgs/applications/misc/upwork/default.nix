{ lib, stdenv, fetchurl, dpkg, wrapGAppsHook, autoPatchelfHook
, alsa-lib, atk, at-spi2-atk, at-spi2-core, cairo, cups, dbus, expat, fontconfig, freetype
, gdk-pixbuf, glib, gtk3, libcxx, libdrm, libnotify, libpulseaudio, libuuid, libX11, libxcb
, libXcomposite, libXcursor, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender
, libXScrnSaver, libXtst, mesa, nspr, nss, openssl, pango, systemd }:

stdenv.mkDerivation rec {
  pname = "upwork";
  version = "5.6.10.13";

  src = fetchurl {
    url = "https://upwork-usw2-desktopapp.upwork.com/binaries/v5_6_10_13_3c485d1dd2af4f61/${pname}_${version}_amd64.deb";
    sha256 = "c3e1ecf14c99596f434edf93a2e08f031fbaa167025d1280cf19f68b829d6b79";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    libcxx systemd libpulseaudio
    stdenv.cc.cc alsa-lib atk at-spi2-atk at-spi2-core cairo cups
    dbus expat fontconfig freetype gdk-pixbuf glib gtk3 libdrm libnotify
    libuuid libX11 libxcb libXcomposite libXcursor libXdamage libXext libXfixes
    libXi libXrandr libXrender libXScrnSaver libXtst mesa nspr nss pango systemd
  ];

  libPath = lib.makeLibraryPath buildInputs;

  dontWrapGApps = true;
  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out

    # Now it requires lib{ssl,crypto}.so.1.0.0. Fix based on Spotify pkg.
    # https://github.com/NixOS/nixpkgs/blob/efea022d6fe0da84aa6613d4ddeafb80de713457/pkgs/applications/audio/spotify/default.nix#L129
    mkdir -p $out/lib/upwork
    ln -s ${lib.getLib openssl}/lib/libssl.so $out/lib/upwork/libssl.so.1.0.0
    ln -s ${lib.getLib openssl}/lib/libcrypto.so $out/lib/upwork/libcrypto.so.1.0.0

    sed -e "s|/opt/Upwork|$out/bin|g" -i $out/share/applications/upwork.desktop
    makeWrapper $out/opt/Upwork/upwork \
      $out/bin/upwork \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --prefix LD_LIBRARY_PATH : ${libPath}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Online freelancing platform desktop application for time tracking";
    homepage = "https://www.upwork.com/ab/downloads/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zakkor wolfangaukang ];
  };
}
