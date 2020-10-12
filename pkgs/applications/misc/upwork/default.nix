{ stdenv, fetchurl, dpkg, wrapGAppsHook, autoPatchelfHook, writeShellScript
, alsaLib, atk, at-spi2-atk, at-spi2-core, cairo, cups, dbus, expat, fontconfig, freetype
, gdk-pixbuf, glib, gtk3, libnotify, libX11, libXcomposite, libXcursor, libXdamage, libuuid
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, nspr, nss, libxcb
, pango, systemd, libXScrnSaver, libcxx, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "upwork";
  version = "5.4.7.1";

  src = fetchurl {
    url = "https://updates-desktopapp.upwork.com/binaries/v5_4_7_1_81f361962c74427d/${pname}_5.4.7.1_amd64.deb";
    sha256 = "c443724d37bca942ca126b8b207846a5adb94a92ff9490370f2fe055feee347b";
  };

  dontWrapGApps = true;

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    libcxx systemd libpulseaudio
    stdenv.cc.cc alsaLib atk at-spi2-atk at-spi2-core cairo cups dbus expat fontconfig freetype
    gdk-pixbuf glib gtk3 libnotify libX11 libXcomposite libuuid
    libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
    libXtst nspr nss libxcb pango systemd libXScrnSaver
  ];

  libPath = stdenv.lib.makeLibraryPath buildInputs;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    mv usr $out
    mv opt $out
    sed -e "s|/opt/Upwork|$out/bin|g" -i $out/share/applications/upwork.desktop

    makeWrapper $out/opt/Upwork/upwork \
      $out/bin/upwork \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --prefix LD_LIBRARY_PATH : ${libPath}
  '';

  meta = with stdenv.lib; {
    description = "Online freelancing platform desktop application for time tracking";
    homepage = "https://www.upwork.com/ab/downloads/";
    license = licenses.unfree;
    maintainers = with maintainers; [ zakkor wolfangaukang ];
  };
}
