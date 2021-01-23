{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard-octant-plugin";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wMt/I2zpdM7l+YNwHkAA6sVRWUtlGpN+94jqx2Jy4HA=";
  };

  vendorSha256 = "sha256-fhIIqirEEdqn/n8bBtLw07fEGfnpC/8SOLbkhnytyME=";

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
