{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, testers
, ipatool
}:

buildGoModule rec {
  pname = "ipatool";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "majd";
    repo = "ipatool";
    rev = "v${version}";
    hash = "sha256-e+gkr8i6dVfxyBM5Vi2YpW4eQ4LE2vhgQadLAFeHK4Q=";
  };

  vendorHash = "sha256-aVMWXlHMGdbApKLhuZZpaAYY5QpMMgXc/6f9r79/dTw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/majd/ipatool/v2/cmd.version=${version}"
  ];

  # go generate ./... fails because of a missing module: github.com/golang/mock/mockgen
  # which is required to run the tests, check if next release fixes it.
  # preCheck = ''
  #   go generate ./...
  # '';
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = ipatool;
      command = "ipatool --version";
    };
  };

  meta = with lib; {
    description = "Command-line tool that allows searching and downloading app packages (known as ipa files) from the iOS App Store";
    homepage = "https://github.com/majd/ipatool";
    changelog = "https://github.com/majd/ipatool/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "ipatool";
  };
}
