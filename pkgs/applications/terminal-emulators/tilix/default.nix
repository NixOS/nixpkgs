{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, python3
, pkg-config
, ldc
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
, appstream
}:

stdenv.mkDerivation rec {
  pname = "tilix";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = "${version}";
    sha256 = "sha256:020gr4q7kmqq8vnsh8rw97gf1p2n1yq4d7ncyjjh9l13zkaxqqv9";
  };

  # Default upstream else LDC fails to link
  mesonBuildType = [
    "debugoptimized"
  ];

  nativeBuildInputs = [
    desktop-file-utils
    ldc
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
    appstream
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

  meta = with lib; {
    description = "Tiling terminal emulator following the Gnome Human Interface Guidelines";
    homepage = "https://gnunn1.github.io/tilix-web";
    license = licenses.mpl20;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.linux;
  };
}
