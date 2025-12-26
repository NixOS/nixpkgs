{
  lib,
  buildGoModule,
  go,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.39.2";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = "operator-sdk";
    tag = "v${version}";
    hash = "sha256-2Kv6mDC1MndUgttRYODnI8DZ84RVz8jn3+RpXmOemq0=";
  };

  vendorHash = "sha256-W+q9K2003dJfcjyoN4YMoY98cwBy+nfZCi3tHNLbm1w=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    go
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
    changelog = "https://github.com/operator-framework/operator-sdk/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arnarg ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
