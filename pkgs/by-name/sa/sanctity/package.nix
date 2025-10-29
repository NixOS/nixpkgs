{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "sanctity";
  version = "1.3.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "sanctity";
    rev = "v${version}";
    hash = "sha256-y6xj4A5SHcW747aFE9TfuurNnuUxjTUeKJmzxeiWqVc=";
  };

  cargoHash = "sha256-r+0Qd88slA4ke90U1urVjdoiXwGWv42AViUpRCTucxs=";

  meta = {
    description = "Test the 16 terminal colors in all combinations";
    homepage = "https://codeberg.org/annaaurora/sanctity";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ annaaurora ];
    mainProgram = "sanctity";
  };
}
