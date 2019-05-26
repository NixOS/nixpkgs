{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, dmd, gnome3, dbus
, gsettings-desktop-schemas, desktop-file-utils, gettext, gtkd, libsecret
, glib, perlPackages, wrapGAppsHook, xdg_utils }:

stdenv.mkDerivation rec {
  pname = "tilix";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = version;
    sha256 = "0mg9y4xd2pnv0smibg7dyy733jarvx6qpdqap3sj7fpyni0jvpph";
  };

  nativeBuildInputs = [
    autoreconfHook dmd desktop-file-utils perlPackages.Po4a pkgconfig xdg_utils
    wrapGAppsHook
  ];

  buildInputs = [ gnome3.dconf gettext gsettings-desktop-schemas gtkd dbus libsecret ];

  preBuild = ''
    makeFlagsArray=(
      DCFLAGS='-O -inline -release -version=StdLoggerDisableTrace'
    )
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH ":" "${libsecret}/lib")

    substituteInPlace $out/share/applications/com.gexperts.Tilix.desktop \
      --replace "Exec=tilix" "Exec=$out/bin/tilix"

    # TODO: Won't be needed after the switch to Meson
    substituteInPlace $out/share/dbus-1/services/com.gexperts.Tilix.service \
     --replace "/usr/bin/tilix" "$out/bin/tilix"
  '';

  meta = with stdenv.lib; {
    description = "Tiling terminal emulator following the Gnome Human Interface Guidelines";
    homepage = https://gnunn1.github.io/tilix-web;
    license = licenses.mpl20;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.linux;
  };
}
