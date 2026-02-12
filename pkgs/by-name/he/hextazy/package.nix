{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hextazy";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "0xfalafel";
    repo = "hextazy";
    tag = finalAttrs.version;
    hash = "sha256-ejF2AVVp6Q7pM4tk/lWty83sUTIYhiffjRgn0KJwYO0=";
  };

  cargoHash = "sha256-ER9+SJ8kfXJtdh7XB51rYd20IkjyEqWuon9OXpwKLAA=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/0xfalafel/hextazy";
    changelog = "https://github.com/0xfalafel/hextazy/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
})
