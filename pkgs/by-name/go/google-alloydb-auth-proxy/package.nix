{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "google-alloydb-auth-proxy";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "alloydb-auth-proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z1sTArR6usEkoI/Dp5FUXhjsPeDHVG88GaSbrb9KaaA=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-jEs1oI4Ka87vbFbxt7cLm042wO2Rl5NaISmHBrCHZGw=";

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
