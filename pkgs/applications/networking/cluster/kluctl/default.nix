{ lib, buildGoModule, fetchFromGitHub, testers, makeWrapper, python310, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-WtTBkc9mop+bfMcVLI8k4Bqmift5JG9riF+QbDeiR9c=";
  };

  subPackages = [ "cmd" ];

  vendorHash = "sha256-TckT39wQn4dclcYSfxootv1Lw5+iYxY6/wwdUc1+Z6s=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  # Depends on docker
  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
  ];

  passthru.tests.version = testers.testVersion {
    package = kluctl;
    version = "v${version}";
  };

  postInstall = ''
    mv $out/bin/{cmd,kluctl}
    wrapProgram $out/bin/kluctl \
        --set KLUCTL_USE_SYSTEM_PYTHON 1 \
        --prefix PATH : '${lib.makeBinPath [ python310 ]}'
  '';

  meta = with lib; {
    description = "Missing glue to put together large Kubernetes deployments";
    mainProgram = "kluctl";
    homepage = "https://kluctl.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir netthier ];
  };
}
