{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, dmd, gnome3, dbus
, gsettings-desktop-schemas, desktop-file-utils, gettext, gtkd, libsecret
, perlPackages, wrapGAppsHook, xdg_utils }:

stdenv.mkDerivation rec {
  name = "tilix-${version}";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = "${version}";
    sha256 = "1ixhkssz0xn3x75n2iw6gd3hka6bgmgwfgbvblbjhhx8gcpbw3s7";
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

  postInstall = with gnome3; ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas

    wrapProgram $out/bin/tilix \
      --prefix LD_LIBRARY_PATH ":" "${libsecret}/lib"
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
