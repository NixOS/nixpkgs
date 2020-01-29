{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "yeetgif";
  version = "1.23.5";

  goPackagePath = "github.com/sgreben/yeetgif";

  src = fetchFromGitHub {
    owner = "sgreben";
    repo = pname;
    rev = version;
    sha256 = "1yz4pps8g378lvmi92cnci6msjj7fprp9bxqmnsyn6lqw7s2wb47";
  };

  meta = with lib; {
    description = "gif effects CLI. single binary, no dependencies. linux, osx, windows. #1 workplace productivity booster. #yeetgif #eggplant #golang";
    homepage = "https://github.com/sgreben/yeetgif";
    license = with licenses; [ mit asl20 cc-by-nc-sa-40 ];
    maintainers = with maintainers; [ ajs124 ];
    platforms = platforms.all;
  };
}
