{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.28.0";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    tag = "v${version}";
    hash = "sha256-94N5pOj73HERGqTt6o6MweW9W5bL2W7CBrUa7jQt7fM=";
  };

  vendorHash = "sha256-3cjohavZfK4hoOMPVLvzwp4ORQ00baqtFUhFyA7Z8OM=";

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
