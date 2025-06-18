{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.25.0";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    tag = "v${version}";
    hash = "sha256-6BZ1ZhlskvP1eYS/yMaPgR0gbAUDJS0rS3KId+Lq450=";
  };

  vendorHash = "sha256-WPfeelgKGY0zTfP19+x8PLBrCFpla2uJFstXxJM966o=";

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
