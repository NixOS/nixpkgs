{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard-octant-plugin";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9vl068ZTw6Czf+cWQ0k1lU0pqh7P0YZgLguHkk3M918=";
  };

  vendorSha256 = "sha256-HOvZPDVKZEoL91yyaJRuKThHirY77xlKOtLKARthxn8=";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w")
  '';

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
