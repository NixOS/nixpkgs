{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "katana";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zqcQBRF03TOldfMw/Yw6fdryfW2N5SHOikuliSL0v+A=";
  };

  vendorHash = "sha256-ZcukX+x0csNUxdIERS3ACw728+TsVicsbOqdL6DxgkA=";
=======
    hash = "sha256-q7uOtfxSS6cLZKjnObLAzn+JpC2myEkoTd2TINBhYcU=";
  };

  vendorHash = "sha256-9RoL6gpAJXO2/0UCmpRnh8roZw/txNgb/H0kVTKVxWs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd/katana" ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "katana";
  };
}
