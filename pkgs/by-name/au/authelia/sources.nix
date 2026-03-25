{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.16";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-6rsjwPHxxixcK5S1l3sLb6zW5Qdywc4RFktR0aZEHPk=";
  };
  vendorHash = "sha256-2hEKLSvzCTXs/0s4PQ+0YXWxLAOXPHCnfs3aNGrbnFs=";
  pnpmDepsHash = "sha256-TELjP4Ny03bvFQ//DBYw3Vn85rRIreywUvUXi0gae1c=";
}
