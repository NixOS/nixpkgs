{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "yeetgif";
  version = "1.23.6";

  src = fetchFromGitHub {
    owner = "sgreben";
    repo = pname;
    rev = version;
    sha256 = "05z1ylsra60bb4cvr383g9im94zsph1dgicqbv5p73qgs634ckk7";
  };

  vendorSha256 = null;

  patches = [
    (fetchpatch {
      url = "https://github.com/sgreben/yeetgif/commit/5d2067b9832898c2b1ac51bf6a5f107619038270.patch";
      sha256 = "sha256-3eyqbpPyuQHjAN5mjQyZo0xY6L683T5Ytyx02II/iU4=";
    })
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "gif effects CLI. single binary, no dependencies. linux, osx, windows. #1 workplace productivity booster. #yeetgif #eggplant #golang";
    homepage = "https://github.com/sgreben/yeetgif";
    license = with licenses; [ mit asl20 cc-by-nc-sa-40 ];
    maintainers = with maintainers; [ ajs124 ];
  };
}
