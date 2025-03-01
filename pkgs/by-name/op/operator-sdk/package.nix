{
  lib,
  buildGoModule,
  go,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.39.1";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-+lgpwpLkqpAZ0aScM62gk4l/h44auB7ixhW3ZoT7m64=";
  };

  vendorHash = "sha256-3CtVl3HWUcbXp/U/pTqoCol4kmJqtLsTlcAijGHENtI=";

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

  meta = with lib; {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding";
    homepage = "https://github.com/operator-framework/operator-sdk";
    changelog = "https://github.com/operator-framework/operator-sdk/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnarg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
