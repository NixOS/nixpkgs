{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "e1s";
  version = "1.0.48";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    tag = "v${version}";
    hash = "sha256-pURUTWlj0iOfHpc4BheprfgAuK05sZDGLbCF/T3LN9w=";
  };

  vendorHash = "sha256-1lise/u40Q8W9STsuyrWIbhf2HY+SFCytUL1PTSWvfY=";

  meta = with lib; {
    description = "Easily Manage AWS ECS Resources in Terminal 🐱";
    homepage = "https://github.com/keidarcy/e1s";
    changelog = "https://github.com/keidarcy/e1s/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "e1s";
    maintainers = with maintainers; [
      zelkourban
      carlossless
    ];
  };
}
