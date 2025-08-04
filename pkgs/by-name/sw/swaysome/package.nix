{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "swaysome";
  version = "2.1.2";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = "swaysome";
    rev = version;
    hash = "sha256-2Q88/XgPN+byEo3e1yvwcwSQxPgPTtgy/rNc/Yduo3U=";
  };

  cargoHash = "sha256-/TW1rPg/1t3n4XPBOEhgr1hd5PJMLwghLvQGBbZPZ34=";

  meta = {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ esclear ];
    platforms = lib.platforms.linux;
    mainProgram = "swaysome";
  };
}
