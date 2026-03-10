{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hextazy";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "0xfalafel";
    repo = "hextazy";
    tag = finalAttrs.version;
    hash = "sha256-Q7gTupoyxioxMibiqhhgnvy38EgnAw+ceSuXzElyga8=";
  };

  cargoHash = "sha256-MzshiOBMi5eJiRogfwygybQc6MEW58ZMpKAinmpBp1E=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/0xfalafel/hextazy";
    changelog = "https://github.com/0xfalafel/hextazy/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
})
