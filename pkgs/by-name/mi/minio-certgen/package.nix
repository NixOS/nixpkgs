{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "minio-certgen";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "certgen";
    rev = "v${version}";
    sha256 = "sha256-bYZfQeqPqroMkqJOqHri3l7xscEK9ml/oNLVPBVSDKk=";
  };

  vendorHash = null;

  meta = {
    description = "Simple Minio tool to generate self-signed certificates, and provides SAN certificates with DNS and IP entries";
    downloadPage = "https://github.com/minio/certgen";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bryanasdev000 ];
    mainProgram = "certgen";
  };
}
