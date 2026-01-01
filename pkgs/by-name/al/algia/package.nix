{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "algia";
<<<<<<< HEAD
  version = "0.0.97";
=======
  version = "0.0.87";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "algia";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vja/l0zLoqTDog32YvkSya4wnMCNj/H93xzwipP2msQ=";
  };

  vendorHash = "sha256-JTTWVs0KwceiLy6tpyd48zORiXLc18zwgG1c+ceivKU=";
=======
    hash = "sha256-8E48TLxA+kGObE08NJ3oFsLUY+y1LKQ6f8+kw7EhAzY=";
  };

  vendorHash = "sha256-Yt95kSXAIBxHgX+VUefKrumg9thuvh3c+gnSu/2PSQY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "CLI application for nostr";
    homepage = "https://github.com/mattn/algia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "algia";
  };
}
