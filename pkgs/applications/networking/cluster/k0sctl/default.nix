{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aW7x2XfeFU0z3lwPTsDHudHjdwTtfASgrbKGddVb6Rs=";
  };

  vendorSha256 = "sha256-bsXXWyeZXZLV6igEvyvPpS92FruGiLDx/5CCTKPe0EU=";

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
