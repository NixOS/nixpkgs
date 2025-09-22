{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gogup";
  version = "0.27.9";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${version}";
    hash = "sha256-8pBJcTv3f5ovbtuXuGVmF8m/6CQd19zpoJDs7PtsGcs=";
  };

  vendorHash = "sha256-sLf0Yhc495rOi0/Ww2/1BD5WXGTFyf6SzfTV9TtGzZk=";
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
