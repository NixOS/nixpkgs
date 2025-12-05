{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gogup";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${version}";
    hash = "sha256-n8bYmQcVtiuc55a+/LfS44PbVHCUZ7WUAWOmcodcy9Y=";
  };

  vendorHash = "sha256-ldsGHIKiuVP48taK4kMqtF/xELl+JqAJUCGFKYZdJGU=";
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
