{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  wayland-scanner,
  wayland,
  gtk3,
  gobject-introspection,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-layer-shell";
  version = "0.10.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "devdoc"; # for demo

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "gtk-layer-shell";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Rl0cSIOsHDXlvjGesVoF98S3ehvTIzKOyetEyBCXDgk=";
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
    wayland-scanner
    vala
    wayland-scanner
  ];

  buildInputs = [
    wayland
    gtk3
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dexamples=true"
  ];

  meta = {
    description = "Library to create panels and other desktop components for Wayland using the Layer Shell protocol";
    mainProgram = "gtk-layer-demo";
    homepage = "https://github.com/wmww/gtk-layer-shell";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      eonpatapon
      donovanglover
    ];
    platforms = lib.platforms.linux;
  };
})
