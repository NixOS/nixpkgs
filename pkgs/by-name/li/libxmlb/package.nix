{
  stdenv,
  lib,
  fetchFromGitHub,
  docbook_xml_dtd_43,
  docbook-xsl-nons,
  glib,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  python3,
  shared-mime-info,
  nixosTests,
  xz,
  zstd,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "libxmlb";
  version = "0.3.24";

  outputs = [
    "out"
    "lib"
    "dev"
    "installedTests"
  ]
  ++ lib.optionals withIntrospection [
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libxmlb";
    rev = version;
    hash = "sha256-3Yxq0KZMV9GRmNjZ19eIqGq+UJS4PGyVPS6HBcMEbHo=";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook-xsl-nons
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    gtk-doc
  ];

  buildInputs = [
    glib
    xz
    zstd
  ];

  mesonFlags = [
    "--libexecdir=${placeholder "out"}/libexec"
    (lib.mesonBool "gtkdoc" withIntrospection)
    (lib.mesonBool "introspection" withIntrospection)
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  preCheck = ''
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:${shared-mime-info}/share
  '';

  doCheck = true;

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.libxmlb;
    };
  };

  meta = with lib; {
    description = "Library to help create and query binary XML blobs";
    mainProgram = "xb-tool";
    homepage = "https://github.com/hughsie/libxmlb";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
