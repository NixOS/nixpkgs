{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "e1s";
  version = "1.0.52";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    tag = "v${version}";
    hash = "sha256-ObqCd27gMG1WWqAObZZP1rGLJuh8weCdC0zrLfoPwMo=";
  };

  vendorHash = "sha256-8z2RVT2W8TLXdZBAmi/2fu63pijVgzqSvF9xpGexlQ0=";

  meta = {
    description = "Easily Manage AWS ECS Resources in Terminal";
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
