{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard-octant-plugin";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JTSZtIRVFdUjhQsp2EMukeoVIo6nNx4xofq+3iOZUIk=";
  };

  vendorHash = "sha256-1zrB+CobUBgdpBHRJPpfDYCD6oVWY4j4Met9EqNQQbE=";

  ldflags = [
    "-s" "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/aquasecurity/starboard-octant-plugin";
    changelog = "https://github.com/aquasecurity/starboard-octant-plugin/releases/tag/v${version}";
    description = "Octant plugin for viewing Starboard security information";
    longDescription = ''
      This is an Octant plugin for Starboard which provides visibility into vulnerability assessment reports for
      Kubernetes workloads stored as custom security resources.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
