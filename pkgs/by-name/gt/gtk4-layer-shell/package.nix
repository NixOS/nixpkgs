{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  wayland-protocols,
  wayland-scanner,
  wayland,
  gtk4,
  gobject-introspection,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk4-layer-shell";
  version = "1.1.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "devdoc";
  passthru.bin = finalAttrs.finalPackage.${finalAttrs.outputBin}; # fixes lib.getExe

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "gtk4-layer-shell";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5TBQKy58o/BdAwfaY2Ss/xcn5kkVFedgiNKfGj7x5gM=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    vala
    wayland-scanner
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ mesonEmulatorHook ];

  buildInputs = [
    gtk4
    wayland
    wayland-protocols
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dexamples=true"
  ];

  meta = with lib; {
    description = "Library to create panels and other desktop components for Wayland using the Layer Shell protocol and GTK4";
    mainProgram = "gtk4-layer-demo";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
    platforms = platforms.linux;
  };
})
