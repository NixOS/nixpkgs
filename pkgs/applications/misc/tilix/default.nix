{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, dmd, gnome3, dbus
, gsettings_desktop_schemas, libsecret, desktop_file_utils, gettext, gtkd
, perlPackages, wrapGAppsHook, xdg_utils }:

stdenv.mkDerivation rec {
  name = "tilix-${version}";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = "${version}";
    sha256 = "1vqi68jlbbaky1569kd4lr6p02zsiv7v2rfb8j1pzwj7gydblaac";
  };

  nativeBuildInputs = [
    autoreconfHook dmd desktop_file_utils perlPackages.Po4a pkgconfig xdg_utils
    wrapGAppsHook
  ];
  buildInputs = [ gnome3.dconf gettext gsettings_desktop_schemas gtkd dbus ];

  preBuild = ''
    makeFlagsArray=(PERL5LIB="${perlPackages.Po4a}/lib/perl5")
  '';

  postInstall = with gnome3; ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';


  preFixup = ''
    substituteInPlace $out/share/applications/com.gexperts.Tilix.desktop \
      --replace "Exec=tilix" "Exec=$out/bin/tilix"
    sed -i '/^DBusActivatable=/d' $out/share/applications/com.gexperts.Tilix.desktop
  '';

  meta = with stdenv.lib; {
    description = "Tiling terminal emulator following the Gnome Human Interface Guidelines.";
    homepage = https://gnunn1.github.io/tilix-web;
    license = licenses.mpl20;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.linux;
  };
}
