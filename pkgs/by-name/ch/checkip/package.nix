{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = "checkip";
    tag = "v${version}";
    hash = "sha256-zhc32H4EUjFbU5weab+IQYARSrJXD8zqkxHLgO5jIJs=";
  };

  vendorHash = "sha256-5sUBrzo6wJfaMMvgNflcjB2QNSIeaD2TN7qBao53NFs=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Requires network
  doCheck = false;

  meta = {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    changelog = "https://github.com/jreisinger/checkip/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "checkip";
  };
}
