{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lefthook";
  version = "1.0.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "evilmartians";
    repo = "lefthook";
    sha256 = "sha256-UpMzqp4NVvj/Y3OdtI5nGhJHgPIfSlopmyv7jDDpWdM=";
  };

  vendorSha256 = "sha256-LCBQyVSkUywceIlioYRNuRc6FrbPKuhgfw5OocR3NvI=";

  doCheck = false;

  meta = with lib; {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/Arkweid/lefthook";
    license = licenses.mit;
    maintainers = with maintainers; [ rencire ];
  };
}
