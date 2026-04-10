{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clavy";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rami3l";
    repo = "clavy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2GDZKvIHhsAUUXRIU6Ql6TF1tGY6wNNeekZRStbux3o=";
  };

  cargoHash = "sha256-qfL4RIaznfiucYf7qhu3PH0acqNI32uZW77BlvqYHqY=";

  nativeBuildInputs = [
    git # Git2 support
  ];

  meta = {
    description = "An input source switching daemon for macOS";
    longDescription = ''
      clavy (formerly claveilleur) is a simple input source switching daemon for macOS.
      Inspired by a native Windows functionality, clavy can automatically switch the
      current input source for you according to the current application (rather than
      the current document). This is especially useful for polyglot users who often
      need to switch between languages depending on the application they are using.
    '';
    homepage = "https://github.com/rami3l/clavy";
    changelog = "https://github.com/rami3l/clavy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "clavy";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.darwin;
  };
})
