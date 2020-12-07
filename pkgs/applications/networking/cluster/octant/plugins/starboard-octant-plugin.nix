{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard-octant-plugin";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "140m7mnpqhfbp2qqpr3jjsc770xdph98mm5zpgwzg0jwgpsrcxsm";
  };

  vendorSha256 = "0aphx2rpnvzmfyfs11hf8j5b7s5lgw4kcq4jpdrkjwx7zhl6qx2g";

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
