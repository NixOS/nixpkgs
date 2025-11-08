{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gogup";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${version}";
    hash = "sha256-VhkmBTU+Zov7w6t/StgQFM9iB36e114pR3Zo4QO3v7k=";
  };

  vendorHash = "sha256-jFeP/0cwAWECuuqLwvMas4Nr7gjyB3BPPfD825yglwE=";
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
