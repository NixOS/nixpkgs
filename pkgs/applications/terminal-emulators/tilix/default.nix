{ lib, stdenv
, fetchFromGitHub
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
, wrapGAppsHook
, libunwind
, appstream
, nixosTests
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "tilix";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = version;
    sha256 = "sha256-sPVL5oYDOmloRVm/nONKkC20vZc907c7ixBF6E2PQ8Y=";
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

  patches = [
    # https://github.com/gnunn1/tilix/issues/2151
    (fetchpatch {
      name = "tilix-replace-std-xml-with-gmarkup.patch";
      url = "https://github.com/gnunn1/tilix/commit/b02779737997a02b98b690e6f8478d28d5e931a5.patch";
      hash = "sha256-6p+DomJEZ/hCW8RTjttKsTDsgHZ6eFKj/71TU5O/Ysg=";
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

  passthru.tests.test = nixosTests.terminal-emulators.tilix;

  meta = with lib; {
    description = "Tiling terminal emulator following the Gnome Human Interface Guidelines";
    homepage = "https://gnunn1.github.io/tilix-web";
    license = licenses.mpl20;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.linux;
    mainProgram = "tilix";
  };
}
