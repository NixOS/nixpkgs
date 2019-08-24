{ stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, python3
, pkgconfig
, dmd
, gnome3
, dbus
, gsettings-desktop-schemas
, desktop-file-utils
, gettext
, gtkd
, libsecret
, glib
, wrapGAppsHook
, libunwind
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "tilix";
  version = "unstable-2019-08-03";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = "09ec4e8e113703ca795946d8d2a83091e7b741e4";
    sha256 = "1vvp6l25xygzhbhscg8scik8y59nl8a92ri024ijk0c0lclga05m";
  };

  # Default upstream else LDC fails to link
  mesonBuildType = [
    "debugoptimized"
  ];

  nativeBuildInputs = [
    desktop-file-utils
    dmd
    hicolor-icon-theme # for setup-hook
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
    gettext
    gnome3.dconf
    gsettings-desktop-schemas
    gtkd
    libsecret
    libunwind
  ];

  patches = [
    # Depends on libsecret optionally
    # https://github.com/gnunn1/tilix/pull/1745
    (fetchpatch {
      url = "https://github.com/gnunn1/tilix/commit/e38dd182bfb92419d70434926ef9c0530189aab8.patch";
      sha256 = "1ws4iyzi67crzlp9p7cw8jr752b3phcg5ymx5aj0bh6321g38kfk";
    })
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    substituteInPlace $out/share/applications/com.gexperts.Tilix.desktop \
      --replace "Exec=tilix" "Exec=$out/bin/tilix"
  '';

  meta = with stdenv.lib; {
    description = "Tiling terminal emulator following the Gnome Human Interface Guidelines";
    homepage = https://gnunn1.github.io/tilix-web;
    license = licenses.mpl20;
    maintainers = with maintainers; [ midchildan worldofpeace ];
    platforms = platforms.linux;
  };
}
