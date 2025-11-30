{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdfried";
  version = "0.14.6";

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ys/CoyaIKVVRtQfmjc4XOABdrktZ1lIPNqw0V8jlY5I=";
  };

  cargoHash = "sha256-ipNhqxcc+Kfr6XtF3QtFh896YK5v1u4kXapiMUjC9n8=";

  doCheck = true;

  meta = {
    description = "Markdown viewer TUI for the terminal, with big text and image rendering";
    homepage = "https://github.com/benjajaja/mdfried";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benjajaja ];
    platforms = lib.platforms.unix;
    mainProgram = "mdfried";
  };
})
