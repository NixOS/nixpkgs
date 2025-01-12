{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "snowcat";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EulQYGOMIh952e4Xp13hT/HMW3qP1QXYtt5PEej1VTY=";
  };
  vendorHash = "sha256-D6ipwGMxT0B3uYUzg6Oo2TYnsOVBY0mYO5lC7vtVPc0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/praetorian-inc/snowcat";
    changelog = "https://github.com/praetorian-inc/snowcat/releases/tag/v${version}";
    description = "Tool to audit the istio service mesh";
    mainProgram = "snowcat";
    longDescription = ''
      Snowcat gathers and analyzes the configuration of an Istio cluster and
      audits it for potential violations of security best practices.

      There are two main modes of operation for Snowcat. With no positional
      argument, Snowcat will assume it is running inside of a cluster enabled
      with Istio, and begin to enumerate the required data. Optionally, you can
      point snowcat at a directory containing Kubernets YAML files.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
