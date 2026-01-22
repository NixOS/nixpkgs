{
  lib,
  buildGoModule,
  golangci-lint,
  writableTmpDirAsHomeHook,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "golangci-lint-langserver";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "nametake";
    repo = "golangci-lint-langserver";
    tag = "v${version}";
    hash = "sha256-mwYhOUH5PAbPRfP86dw9w6lIZYz/iL+f863XWOhBFy0=";
  };

  vendorHash = "sha256-kbGTORTTxfftdU8ffsfh53nT7wZldOnBZ/1WWzN89Uc=";

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
