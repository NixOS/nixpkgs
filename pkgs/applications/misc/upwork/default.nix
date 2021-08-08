{ lib, stdenv, fetchurl, dpkg, wrapGAppsHook, autoPatchelfHook
, alsa-lib, atk, at-spi2-atk, at-spi2-core, cairo, cups, dbus, expat, fontconfig, freetype
, gdk-pixbuf, glib, gtk3, libnotify, libX11, libXcomposite, libXcursor, libXdamage, libuuid
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, nspr, nss, libxcb
, pango, systemd, libXScrnSaver, libcxx, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "upwork";
  version = "5.5.0.11";

  src = fetchurl {
    url = "https://upwork-usw2-desktopapp.upwork.com/binaries/v5_5_0_11_61df9c99b6df4e7b/${pname}_${version}_amd64.deb";
    sha256 = "db83d5fb1b5383992c6156284f6f3cd3a6b23f727ce324ba90c82817553fb4f7";
  };

  dontWrapGApps = true;

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    libcxx systemd libpulseaudio
    stdenv.cc.cc alsa-lib atk at-spi2-atk at-spi2-core cairo cups dbus expat fontconfig freetype
    gdk-pixbuf glib gtk3 libnotify libX11 libXcomposite libuuid
    libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
    libXtst nspr nss libxcb pango systemd libXScrnSaver
  ];

  libPath = lib.makeLibraryPath buildInputs;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    runHook preInstall
    mv usr $out
    mv opt $out
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
    license = licenses.unfree;
    maintainers = with maintainers; [ zakkor wolfangaukang ];
  };
}
