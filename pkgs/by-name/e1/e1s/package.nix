{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "e1s";
  version = "1.0.49";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    tag = "v${version}";
    hash = "sha256-7GHNhX0hiRHQ0OH1DuHG9SPcTmm8W5CLU1Idx1pJnwE=";
  };

  vendorHash = "sha256-1lise/u40Q8W9STsuyrWIbhf2HY+SFCytUL1PTSWvfY=";

  meta = {
    description = "Easily Manage AWS ECS Resources in Terminal 🐱";
    homepage = "https://github.com/keidarcy/e1s";
    changelog = "https://github.com/keidarcy/e1s/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "e1s";
    maintainers = with lib.maintainers; [
      zelkourban
      carlossless
    ];
  };
}
