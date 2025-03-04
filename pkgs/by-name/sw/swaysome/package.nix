{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "swaysome";
  version = "2.1.2";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = pname;
    rev = version;
    hash = "sha256-2Q88/XgPN+byEo3e1yvwcwSQxPgPTtgy/rNc/Yduo3U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/TW1rPg/1t3n4XPBOEhgr1hd5PJMLwghLvQGBbZPZ34=";

  meta = with lib; {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = licenses.mit;
    maintainers = with maintainers; [ esclear ];
    platforms = platforms.linux;
    mainProgram = "swaysome";
  };
}
