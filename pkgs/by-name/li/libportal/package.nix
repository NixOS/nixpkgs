{
  stdenv,
  lib,
  fetchFromGitHub,
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
  version = "0.8.1";

  outputs = [
    "out"
    "dev"
  ] ++ lib.optional (variant != "qt5") "devdoc";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "libportal";
    rev = version;
    sha256 = "sha256-NAkD5pAQpmAtVxsFZt74PwURv+RbGBfqENIwyxEEUSc=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      gi-docgen
    ]
    ++ lib.optionals (variant != "qt5") [
      gobject-introspection
      vala
    ];

  propagatedBuildInputs =
    [
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
  };
}
