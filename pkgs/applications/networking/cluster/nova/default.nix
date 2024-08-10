{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nova";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2jm9FoB8CPvnqJABotPhlvJdgZTtuvntzqWmQ2Li7W4=";
  };

  vendorHash = "sha256-m9gCsWvZ55Wv8PFV3x+tjlEZ4oDFVBbOSnvsjPTvR6k=";

  ldflags = [ "-X main.version=${version}" "-s" "-w" ];

  meta = with lib; {
    description = "Find outdated or deprecated Helm charts running in your cluster";
    mainProgram = "nova";
    longDescription = ''
      Nova scans your cluster for installed Helm charts, then
      cross-checks them against all known Helm repositories. If it
      finds an updated version of the chart you're using, or notices
      your current version is deprecated, it will let you know.
    '';
    homepage = "https://nova.docs.fairwinds.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
