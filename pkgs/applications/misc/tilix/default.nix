{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, dmd, gnome3, dbus
, gsettings_desktop_schemas, libsecret, desktop_file_utils, gettext, gtkd
, perlPackages, wrapGAppsHook, xdg_utils }:

stdenv.mkDerivation rec {
  name = "tilix-${version}";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = "${version}";
    sha256 = "0x0bnb26hjvxmvvd7c9k8fw97gcm3z5ssr6r8x90xbyyw6h58hhh";
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
    licence = licenses.mpl20;
    maintainer = with maintainers; [ midchildan ];
    platforms = platforms.linux;
  };
}
