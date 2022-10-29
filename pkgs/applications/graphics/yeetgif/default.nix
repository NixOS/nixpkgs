{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yeetgif";
  version = "unstable-2021-11-20";

  src = fetchFromGitHub {
    owner = "sgreben";
    repo = pname;
    rev = "5d2067b9832898c2b1ac51bf6a5f107619038270";
    sha256 = "sha256-Z22Cs5xFYglr6yqam1DXdQVE50DBjgb+v9MHJOI7uFQ=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "gif effects CLI. single binary, no dependencies. linux, osx, windows. #1 workplace productivity booster. #yeetgif #eggplant #golang";
    homepage = "https://github.com/sgreben/yeetgif";
    license = with licenses; [ mit asl20 cc-by-nc-sa-40 ];
    maintainers = with maintainers; [ ajs124 ];
  };
}
