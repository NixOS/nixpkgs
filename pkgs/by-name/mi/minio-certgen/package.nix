{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "minio-certgen";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "certgen";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Fuuq48+/ry6h9iA4WBXnahJp6EP640St84Tu6B86weI=";
  };

  vendorHash = null;

  meta = {
    description = "Simple Minio tool to generate self-signed certificates, and provides SAN certificates with DNS and IP entries";
    downloadPage = "https://github.com/minio/certgen";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "certgen";
  };
})
