{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nova";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-K4D8vCZxOPRalSDlAmva7Qm72EJ2Xdz20oqKKqkD6iA=";
  };

  vendorHash = "sha256-c30B8Wjvwp4NnB1P8h4/raGiGAX/cbTZ/KQqh/qeNhA=";

  ldflags = [ "-X main.version=${version}" "-s" "-w" ];

  meta = with lib; {
    description = "Find outdated or deprecated Helm charts running in your cluster";
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
