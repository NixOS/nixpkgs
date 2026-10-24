{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  gobject-introspection,
  gi-docgen,
  glib,
  gst_all_1,
  libspeechprovider,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspiel";
  version = "1.0.3";

  outputs = [
    "out"
    "dev"
    # "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "project-spiel";
    repo = "libspiel";
    rev = "SPIEL_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-brxSRfQD71BWeoQ4bZILxyiFZY31uU8b5e/qCZ/AxPk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    gobject-introspection
    gi-docgen
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libspeechprovider
  ];

  propagatedBuildInputs = [
    glib
  ];

  strictDeps = true;

  # postFixup = ''
  #   # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
  #   moveToOutput "share/doc" "$devdoc"
  # '';

  meta = {
    description = "Speech synthesis client library";
    homepage = "https://github.com/project-spiel/libspiel";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ jtojnar ];
    mainProgram = "spiel";
    platforms = lib.platforms.unix;
  };
})
