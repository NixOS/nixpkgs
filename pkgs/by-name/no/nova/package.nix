{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nova";
  version = "3.11";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gkEUc2mhm1r69XzAnglLhdyYI4jQ24oEk/NRMgeyw60=";
  };

  vendorHash = "sha256-v3ld3bHpVWNJgQ6K5iS7q8QV4ft4RE42wKi+f4++yqY=";

  ldflags = [
    "-X main.version=${version}"
    "-s"
    "-w"
  ];

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
