{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lefthook";
  version = "1.0.4";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "evilmartians";
    repo = "lefthook";
    sha256 = "sha256-uaIZrxfzV2WPvnAPm6Q67yKx1EVmSMcChSxZG/Huw48=";
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
