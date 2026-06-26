{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "google-cloud-sql-proxy";
  version = "2.22.1";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloud-sql-proxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vTTYQ1D42X1L03EE9c5Xz/SCRE3wWROT/daY+f0vLPI=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-lOT9GpZk6Bv5P8kiyMR4j+aHOO0be4pW4WvVux8hpnQ=";

  checkFlags = [
    "-short"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility for ensuring secure connections to Google Cloud SQL instances";
    longDescription = ''
      The Cloud SQL Auth Proxy is a utility for ensuring secure connections to your Cloud SQL instances.
      It provides IAM authorization, allowing you to control who can connect to your instance through IAM permissions,
      and TLS 1.3 encryption, without having to manage certificates.
      See the [Connecting Overview](https://cloud.google.com/sql/docs/mysql/connect-overview) page for more information
      on connecting to a Cloud SQL instance, or the [About the Proxy](https://cloud.google.com/sql/docs/mysql/sql-proxy)
      page for details on how the Cloud SQL Proxy works.
    '';
    homepage = "https://github.com/GoogleCloudPlatform/cloud-sql-proxy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nicknovitski
      totoroot
    ];
    mainProgram = "cloud-sql-proxy";
  };
})
