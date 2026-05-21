{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hextazy";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "0xfalafel";
    repo = "hextazy";
    tag = finalAttrs.version;
    hash = "sha256-pQhSel/DgdosvH2H90PIc51GEYhWx31WWkvOPKcUp1I=";
  };

  cargoHash = "sha256-0uEiL85ypKr/9r0okrm4pqLRZOYDIUFxmobqK7Jm1Jw=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/0xfalafel/hextazy";
    changelog = "https://github.com/0xfalafel/hextazy/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
})
