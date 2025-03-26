{
  lib,
  buildGoModule,
  golangci-lint,
  writableTmpDirAsHomeHook,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "golangci-lint-langserver";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "nametake";
    repo = "golangci-lint-langserver";
    tag = "v${version}";
    hash = "sha256-wNofr/s8K+vbvNZWrQ97g2V0fNAS2P/Zf7tsOmly+gc=";
  };

  vendorHash = "sha256-SsGw26y/ZIBFp9dBk55ebQgJiLWOFRNe21h6huYE84I=";

  subPackages = [ "." ];

  nativeCheckInputs = [
    golangci-lint
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Language server for golangci-lint";
    homepage = "https://github.com/nametake/golangci-lint-langserver";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kirillrdy ];
    mainProgram = "golangci-lint-langserver";
  };
}
