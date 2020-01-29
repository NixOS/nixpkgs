{ stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, python3
, pkgconfig
, dmd
, dconf
, dbus
, gsettings-desktop-schemas
, desktop-file-utils
, gettext
, gtkd
, libsecret
, glib
, wrapGAppsHook
, libunwind
}:

stdenv.mkDerivation {
  pname = "tilix";
  version = "unstable-2019-10-02";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = "ffcd31e3c0e1a560ce89468152d8726065e8fb1f";
    sha256 = "1bzv7xiqhyblz1rw8ln4zpspmml49vnshn1zsv9di5q7kfgpqrgq";
  };

  # Default upstream else LDC fails to link
  mesonBuildType = [
    "debugoptimized"
  ];

  nativeBuildInputs = [
    desktop-file-utils
    dmd
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
    gettext
    dconf
    gsettings-desktop-schemas
    gtkd
    libsecret
    libunwind
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
