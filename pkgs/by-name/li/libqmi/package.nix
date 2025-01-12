{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  help2man,
  glib,
  python3,
  mesonEmulatorHook,
  libgudev,
  bash-completion,
  libmbim,
  libqrtr-glib,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  withMan ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.34.0";

  outputs = [
    "out"
    "dev"
  ] ++ lib.optional withIntrospection "devdoc";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "libqmi";
    rev = version;
    hash = "sha256-l9ev9ZOWicVNZ/Wj//KNd3NHcefIrLVriqJhEpwWvtQ=";
  };

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      python3
    ]
    ++ lib.optionals withMan [
      help2man
    ]
    ++ lib.optionals withIntrospection [
      gobject-introspection
      gtk-doc
      docbook-xsl-nons
      docbook_xml_dtd_43
    ]
    ++ lib.optionals (withIntrospection && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      mesonEmulatorHook
    ];

  buildInputs =
    [
      bash-completion
      libmbim
    ]
    ++ lib.optionals withIntrospection [
      libgudev
    ];

  propagatedBuildInputs =
    [
      glib
    ]
    ++ lib.optionals withIntrospection [
      libqrtr-glib
    ];

  mesonFlags = [
    "-Dudevdir=${placeholder "out"}/lib/udev"
    (lib.mesonBool "gtk_doc" withIntrospection)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "man" withMan)
    (lib.mesonBool "qrtr" withIntrospection)
    (lib.mesonBool "udev" withIntrospection)
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      build-aux/qmi-codegen/qmi-codegen
  '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/libqmi/";
    description = "Modem protocol helper library";
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
    license = with licenses; [
      # Library
      lgpl2Plus
      # Tools
      gpl2Plus
    ];
    changelog = "https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/blob/${version}/NEWS";
  };
}
