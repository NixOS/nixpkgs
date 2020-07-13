{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-migrator";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "fs-repo-migrations";
    rev = "v${version}";
    sha256 = "13ah5jk8n3wznvag6dda1ssgpqsdr9pdgvqm9gcsb7zzls89j9x5";
  };

  vendorSha256 = null;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Migrations for the filesystem repository of ipfs clients";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ elitak ];
  };
}
