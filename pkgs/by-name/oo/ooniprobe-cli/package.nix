{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.24.0";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-jg09yIX3jHMp0PwSwy2RMwYhZm0haJFTmpwcyTc5I0A=";
  };

  vendorHash = "sha256-QH5PyCvfJWWDhjH6Jo8O3wBq3MwfpHWKSuYMmpaqjWk=";

  subPackages = [ "cmd/ooniprobe" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    changelog = "https://github.com/ooni/probe-cli/releases/tag/${src.rev}";
    description = "Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
