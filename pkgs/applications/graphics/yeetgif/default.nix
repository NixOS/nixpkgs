{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "yeetgif";
  version = "1.23.6";

  goPackagePath = "github.com/sgreben/yeetgif";

  src = fetchFromGitHub {
    owner = "sgreben";
    repo = pname;
    rev = version;
    sha256 = "05z1ylsra60bb4cvr383g9im94zsph1dgicqbv5p73qgs634ckk7";
  };

  meta = with lib; {
    description = "gif effects CLI. single binary, no dependencies. linux, osx, windows. #1 workplace productivity booster. #yeetgif #eggplant #golang";
    homepage = "https://github.com/sgreben/yeetgif";
    license = with licenses; [ mit asl20 cc-by-nc-sa-40 ];
    maintainers = with maintainers; [ ajs124 ];
  };
}
