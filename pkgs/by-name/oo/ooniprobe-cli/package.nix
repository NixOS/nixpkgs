{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.27.0";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    tag = "v${version}";
    hash = "sha256-dVYxq/ojE3nPxdkQEXocJJKNXeaaS+Sdq+CO8j5M5jM=";
  };

  vendorHash = "sha256-JnvP0PUOYNJLBpY9BWlC6cJ+Sor2gxDgSKJ8KnUctWc=";

  subPackages = [ "cmd/ooniprobe" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    changelog = "https://github.com/ooni/probe-cli/releases/tag/${src.tag}";
    description = "Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
