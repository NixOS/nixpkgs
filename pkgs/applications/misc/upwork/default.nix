{ lib, stdenv, fetchurl, dpkg, wrapGAppsHook, autoPatchelfHook
, alsa-lib, atk, at-spi2-atk, at-spi2-core, cairo, cups, dbus, expat, fontconfig, freetype
, gdk-pixbuf, glib, gtk3, libcxx, libdrm, libnotify, libpulseaudio, libuuid, libX11, libxcb
, libXcomposite, libXcursor, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender
, libXScrnSaver, libXtst, mesa, nspr, nss, pango, systemd }:

stdenv.mkDerivation rec {
  pname = "upwork";
  version = "5.6.8.0";

  src = fetchurl {
    url = "https://upwork-usw2-desktopapp.upwork.com/binaries/v5_6_8_0_836f43f6f6be4149/${pname}_${version}_amd64.deb";
    sha256 = "b3a52f773d633837882dc107b206006325722ca5d5d5a1e8bdf5453f872e1b6f";
  };

  dontWrapGApps = true;

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
