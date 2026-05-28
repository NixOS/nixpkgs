{
  lib,
  buildGoModule,
  go,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  gpgme,
}:

buildGoModule (finalAttrs: {
  pname = "operator-sdk";
  version = "1.42.2";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = "operator-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jBSHrSqeUVePQ6ZOF2cooHImoplsMgxgpXdvQ/3zxrA=";
  };

  vendorHash = "sha256-0cggdw8UC7iTgYXEgxcIp+Xyvu4FDUhg/tTGwx7kqxI=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    go
    gpgme
  ];

  doCheck = false;

  subPackages = [
    "cmd/helm-operator"
    "cmd/operator-sdk"
  ];

  # operator-sdk uses the go compiler at runtime
  allowGoReference = true;

  postFixup = ''
    wrapProgram $out/bin/operator-sdk --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding";
    homepage = "https://github.com/operator-framework/operator-sdk";
    changelog = "https://github.com/operator-framework/operator-sdk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arnarg ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
