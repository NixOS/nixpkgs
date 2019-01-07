{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, dmd, gnome3, dbus
, gsettings-desktop-schemas, desktop-file-utils, gettext, gtkd, libsecret
, appstream-glib, libunwind, perlPackages, wrapGAppsHook, xdg_utils }:

stdenv.mkDerivation rec {
  name = "tilix-${version}";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = "${version}";
    sha256 = "1l1ib3g01mxiywbwjxc2522qgjy3ymjzy8bxl42k0hprpp95rw9d";
  };

  nativeBuildInputs = [
    meson ninja dmd desktop-file-utils perlPackages.Po4a pkgconfig xdg_utils
    appstream-glib wrapGAppsHook
  ];
  buildInputs = [ gnome3.dconf gettext gsettings-desktop-schemas gtkd dbus libsecret libunwind ];

  # Don't use dub to fetch and build dependencies
  patches = [ ./no-dub.patch ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  postInstall = with gnome3; ''
    wrapProgram $out/bin/tilix \
      --prefix LD_LIBRARY_PATH ":" "${libsecret}/lib"
  '';


  preFixup = ''
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
