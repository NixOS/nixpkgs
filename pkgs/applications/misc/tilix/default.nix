{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, dmd, gnome3, dbus
, gsettings-desktop-schemas, desktop-file-utils, gettext, gtkd, libsecret
, glib, perlPackages, wrapGAppsHook, xdg_utils }:

stdenv.mkDerivation rec {
  pname = "tilix";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = version;
    sha256 = "1l1ib3g01mxiywbwjxc2522qgjy3ymjzy8bxl42k0hprpp95rw9d";
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
    sed -i '/^DBusActivatable=/d' $out/share/applications/com.gexperts.Tilix.desktop
  '';

  meta = with stdenv.lib; {
    description = "Tiling terminal emulator following the Gnome Human Interface Guidelines";
    homepage = https://gnunn1.github.io/tilix-web;
    license = licenses.mpl20;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.linux;
  };
}
