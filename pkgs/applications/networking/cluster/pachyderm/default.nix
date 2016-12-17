{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "pachyderm-${version}";
  version = "1.3.0";
  rev = "v${version}";

  goPackagePath = "github.com/pachyderm/pachyderm";
  subPackages = [ "src/server/cmd/pachctl" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "pachyderm";
    repo = "pachyderm";
    sha256 = "0y25xh6h7p8hg0bzrjlschmz62r6dwh5mrvbnni1hb1pm0w9jb6g";
  };

  meta = with lib; {
    description = "Containerized Data Analytics";
    homepage = https://github.com/pachyderm/pachyderm;
    license = licenses.asl20;
    maintainers = with maintainers; [offline];
  };
}
