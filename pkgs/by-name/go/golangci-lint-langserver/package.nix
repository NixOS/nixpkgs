{
  lib,
  buildGoModule,
  golangci-lint,
  writableTmpDirAsHomeHook,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "golangci-lint-langserver";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "nametake";
    repo = "golangci-lint-langserver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sm+y9ccM5zhatzDZ/qDYH4HT2foteCniItdojqnFSxI=";
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
})
