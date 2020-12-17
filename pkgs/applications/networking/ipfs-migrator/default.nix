{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs-migrator";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "fs-repo-migrations";
    rev = "v${version}";
    sha256 = "0s2mmprhhb04i8pa3lfgb61wvlrp44xnb4d08y7vd2i82lmh234b";
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
