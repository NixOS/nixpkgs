{
  buildGo124Module,
  fetchFromGitHub,
  lib,
}:

buildGo124Module rec {
  pname = "minio-kes";
  version = "2025-03-12T09-35-18Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "kes";
    rev = version;
    hash = "sha256-S2RdYe07MbQ2xTJLOHYG7rHWxzEeZn6JwjyuWDbkTkY=";
  };

  vendorHash = "sha256-+n1yiAD7STcf73fpkQEPczHK0Pv2ESkdBE8KA4pNsBk=";

  meta = with lib; {
    homepage = "https://min.io/docs/kes/concepts/";
    description = "Key Managament Server for Object Storage and more";
    license = licenses.agpl3Plus;
    teams = [ teams.helsinki-systems ];
    mainProgram = "kes";
  };
}
