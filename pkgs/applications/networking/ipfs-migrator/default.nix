{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-migrator";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "fs-repo-migrations";
    rev = "v${version}";
    sha256 = "18pjxkxfbsbbj4hs4xyzfmmz991h31785ldx41dll6wa9zx4lsnm";
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