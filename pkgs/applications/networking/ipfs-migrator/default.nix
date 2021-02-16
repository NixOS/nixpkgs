{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-migrator";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "fs-repo-migrations";
    rev = "v${version}";
    sha256 = "sha256-MxEKmoveIpuxBkGGGJHp9T11i3Py8a1fLpF0fWk0ftg=";
  };

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Migrations for the filesystem repository of ipfs clients";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ elitak ];
  };
}
