{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "google-alloydb-auth-proxy";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "alloydb-auth-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TNb5rXKpVfqi4aPdB1qlQFVnxmcblrgmODeZtmS4XgA=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-j+jMwkW2yNEEd7TA5gUNRgKOOrm4w4U3ZfP7yErd13M=";

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
    changelog = "https://github.com/GoogleCloudPlatform/alloydb-auth-proxy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShawnToubeau ];
    mainProgram = "alloydb-auth-proxy";
  };
})
