{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "google-alloydb-auth-proxy";
  version = "1.13.6";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "alloydb-auth-proxy";
    tag = "v${version}";
    hash = "sha256-d3YMyvUoNfU32pcStsriBCCiyMPHRZrJzHgrnBRmUL4=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-DobqGejaRrCy8RJyydepnTVp9IdeM9X6A+3uUgH15iM=";

  checkFlags = [
    "-short"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility for connecting securely to your AlloyDB instances";
    longDescription = ''
      The AlloyDB Auth Proxy is a binary that provides IAM-based authorization and encryption when connecting to an AlloyDB instance.

      See the Connecting Overview page for more information on connecting to an AlloyDB instance, or the About the proxy page for details on how the AlloyDB Auth Proxy works.
    '';
    homepage = "https://github.com/GoogleCloudPlatform/alloydb-auth-proxy";
    changelog = "https://github.com/GoogleCloudPlatform/alloydb-auth-proxy/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShawnToubeau ];
    mainProgram = "alloydb-auth-proxy";
  };
}
