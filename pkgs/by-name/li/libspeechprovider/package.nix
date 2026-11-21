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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspeechprovider";
  version = "1.0.3";

  outputs = [
    "out"
    "dev"
    # "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "project-spiel";
    repo = "libspeechprovider";
    rev = "SPEECHPROVIDER_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}}";
    hash = "sha256-OUIK2PWnAh6zEqYV8a/YJw8L0bsewA5wnD3rEbIFZ3U=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    gobject-introspection
    gi-docgen
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
    description = "Speech Provider Resources";
    homepage = "https://github.com/project-spiel/libspeechprovider";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.unix;
  };
})
