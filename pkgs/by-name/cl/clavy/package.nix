{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clavy";
  version = "0.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rami3l";
    repo = "clavy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9EhxUa2z0aBnvFJ/h/5xD0sG7yxEpp5F0XG5Paoj0es=";
  };

  cargoHash = "sha256-giqr84nuFh94jIQjqAxmxDiBQ68375+6TD9BQSWkYkU=";

  nativeBuildInputs = [
    git # Git2 support
  ];

  meta = {
    description = "Input source switching daemon for macOS";
    longDescription = ''
      clavy (formerly claveilleur) is a simple input source switching daemon for macOS.
      Inspired by a native Windows functionality, clavy can automatically switch the
      current input source for you according to the current application (rather than
      the current document). This is especially useful for polyglot users who often
      need to switch between languages depending on the application they are using.
    '';
    homepage = "https://github.com/rami3l/clavy";
    changelog = "https://github.com/rami3l/clavy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "clavy";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.darwin;
  };
})
