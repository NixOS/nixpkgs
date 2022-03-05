{ lib, stdenv, fetchurl, dpkg, wrapGAppsHook, autoPatchelfHook
, alsa-lib, atk, at-spi2-atk, at-spi2-core, cairo, cups, dbus, expat, fontconfig, freetype
, gdk-pixbuf, glib, gtk3, libcxx, libdrm, libnotify, libpulseaudio, libuuid, libX11, libxcb
, libXcomposite, libXcursor, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender
, libXScrnSaver, libXtst, mesa, nspr, nss, pango, systemd }:

stdenv.mkDerivation rec {
  pname = "upwork";
  version = "5.6.10.1";

  src = fetchurl {
    url = "https://upwork-usw2-desktopapp.upwork.com/binaries/v5_6_10_1_de501d28cc034306/${pname}_${version}_amd64.deb";
    sha256 = "8faf896d2570d1d210793f46a3860e934d03498c1f11640d43721b6eb2b56860";
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
