{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  glib,
  gtk3,
  gtk4,
  libsForQt5,
  qt6Packages,
  variant ? null,
}:

assert
  variant == null || variant == "gtk3" || variant == "gtk4" || variant == "qt5" || variant == "qt6";

stdenv.mkDerivation rec {
  pname = "libportal" + lib.optionalString (variant != null) "-${variant}";
  version = "0.9.1";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional (variant != "qt5") "devdoc";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "libportal";
    rev = version;
    sha256 = "sha256-CXI4rBr9wxLUX537d6SNNf8YFR/J6YdeROlFt3edeOU=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gi-docgen
  ]
  ++ lib.optionals (variant != "qt5") [
    gobject-introspection
    vala
  ];

  propagatedBuildInputs = [
    glib
  ]
  ++ lib.optionals (variant == "gtk3") [
    gtk3
  ]
  ++ lib.optionals (variant == "gtk4") [
    gtk4
  ]
  ++ lib.optionals (variant == "qt5") [
    libsForQt5.qtbase
    libsForQt5.qtx11extras
  ]
  ++ lib.optionals (variant == "qt6") [
    qt6Packages.qtbase
  ];

  patches = [
    # See https://github.com/flatpak/libportal/pull/200
    (fetchpatch2 {
      name = "libportal-fix-qt6.9-private-api-usage.patch";
      url = "https://github.com/flatpak/libportal/commit/796053d2eebe4532aad6bd3fd80cdf3b197806ec.patch?full_index=1";
      hash = "sha256-TPIKKnZCcp/bmmsaNlDxAsKLTBe6BKPCTOutLjXPCHQ=";
    })
  ];

  mesonFlags = [
    (lib.mesonEnable "backend-gtk3" (variant == "gtk3"))
    (lib.mesonEnable "backend-gtk4" (variant == "gtk4"))
    (lib.mesonEnable "backend-qt5" (variant == "qt5"))
    (lib.mesonEnable "backend-qt6" (variant == "qt6"))
    (lib.mesonBool "vapi" (variant != "qt5"))
    (lib.mesonBool "introspection" (variant != "qt5"))
    (lib.mesonBool "docs" (variant != "qt5")) # requires introspection=true
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  # we don't have any binaries
  dontWrapQtApps = true;

  meta = {
    description = "Flatpak portal library";
    homepage = "https://github.com/flatpak/libportal";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.unix;
    # needs memfd_create which is available on some unixes but not darwin
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
  };
}
