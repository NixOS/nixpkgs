{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-errorlint";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "polyfloyd";
    repo = "go-errorlint";
    rev = "v${version}";
    hash = "sha256-xO9AC1z3JNTRVEpM/FF8x+AMfmspU64kUywvpMb2yxM=";
  };

  vendorHash = "sha256-pSajd2wyefHgxMvhDKs+qwre4BMRBv97v/tZOjiT3LE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A source code linter that can be used to find code that will cause problems with Go's error wrapping scheme";
    homepage = "https://github.com/polyfloyd/go-errorlint";
    changelog = "https://github.com/polyfloyd/go-errorlint/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
    mainProgram = "go-errorlint";
  };
}
