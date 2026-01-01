{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "e1s";
<<<<<<< HEAD
  version = "1.0.52";
=======
  version = "1.0.51";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ObqCd27gMG1WWqAObZZP1rGLJuh8weCdC0zrLfoPwMo=";
  };

  vendorHash = "sha256-8z2RVT2W8TLXdZBAmi/2fu63pijVgzqSvF9xpGexlQ0=";
=======
    hash = "sha256-9O6VRsO80d+ZvUbqt+AUqph9FXOWlwOdgJcqqiGBNC0=";
  };

  vendorHash = "sha256-1lise/u40Q8W9STsuyrWIbhf2HY+SFCytUL1PTSWvfY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
