{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, dmd, gnome3, dbus
, gsettings_desktop_schemas, libsecret, desktop_file_utils, gettext, gtkd
, perlPackages, wrapGAppsHook, xdg_utils }:

stdenv.mkDerivation rec {
  name = "tilix-${version}";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = "${version}";
    sha256 = "10nw3q6s941dm44bkfryl1xclr1xy1vjr2n8w7g6kfahpcazf8f8";
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
  '';

  meta = with stdenv.lib; {
    description = "Tiling terminal emulator following the Gnome Human Interface Guidelines.";
    homepage = https://gnunn1.github.io/tilix-web;
    licence = licenses.mpl20;
    maintainer = with maintainers; [ midchildan ];
    platforms = platforms.linux;
  };
}
