{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gogup";
<<<<<<< HEAD
  version = "0.28.2";
=======
  version = "0.28.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ETUCMDF0dU2p/nKC07T2rVtDvKRSatqijRu4PanbxXc=";
  };

  vendorHash = "sha256-Dm9g2SA5qYYcmnQ1xApVVvWG7+CaQs5blv7qJOANL8Q=";
=======
    hash = "sha256-n8bYmQcVtiuc55a+/LfS44PbVHCUZ7WUAWOmcodcy9Y=";
  };

  vendorHash = "sha256-ldsGHIKiuVP48taK4kMqtF/xELl+JqAJUCGFKYZdJGU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/nao1215/gup/internal/cmdinfo.Version=v${version}"
  ];

  meta = {
    description = "Update binaries installed by 'go install' with goroutines";
    changelog = "https://github.com/nao1215/gup/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/nao1215/gup";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "gup";
  };
}
