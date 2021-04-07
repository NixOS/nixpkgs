{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard-octant-plugin";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wis2ECCVXQeD7GiCMJQai+wDM8QJ1j5dPnE5O/I3wpM=";
  };

  vendorSha256 = "sha256-T0wDbAl5GXphZIBrM36OwRCojnJ/cbXNqsjtCzUDZ6s=";

  buildFlagsArray = [ "-ldflags=" "-s" "-w" ];

  meta = with lib; {
    description = "Octant plugin for viewing Starboard security information";
    longDescription = ''
      This is an Octant plugin for Starboard which provides visibility into vulnerability assessment reports for
      Kubernetes workloads stored as custom security resources.
    '';
    homepage = src.meta.homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
