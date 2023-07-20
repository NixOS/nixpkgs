{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "stremio-service";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hqps7l5qrjh9f914r5i6kmcz6f1yb951nv4lby0cjnp5l253kps";
  };

  cargoSha256 = "03wf9r2csi6jpa7v5sw5lpxkrk4wfzwmzx7k3991q3bdjzcwnnwp";

  meta = with lib; {
    description = "A companion app for Stremio Web";
    homepage = "https://github.com/Stremio/stremio-service";
    license = licenses.unlicense;
    maintainers = [ ];
  };
}
