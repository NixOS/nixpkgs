{ lib
, buildGoPackage
, fetchFromGitHub }:

buildGoPackage rec {
  pname = "nixops-dns";
  version = "1.0";

  goDeps = ./deps.nix;
  goPackagePath = "github.com/kamilchm/nixops-dns";

  src = fetchFromGitHub {
    owner = "kamilchm";
    repo = "nixops-dns";
    rev = "v${version}";
    sha256 = "1fyqwk2knrv40zpf71a56bjyaycr3p6fzrqq7gaan056ydy83cai";
  };

  meta = with lib; {
    homepage = "https://github.com/kamilchm/nixops-dns/";
    description = "DNS server for resolving NixOps machines";
    license = licenses.mit;
    maintainers = with maintainers; [ kamilchm sorki ];
  };
}
