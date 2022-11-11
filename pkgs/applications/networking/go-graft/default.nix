{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "go-graft";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "mzz2017";
    repo = "gg";
    rev = "v${version}";
    sha256 = "sha256-XymtLguAHCtOrRADRcWsPYq9cZo+FVUPOceIj7SmH8k=";
  };

  CGO_ENABLED = 0;

  ldflags = [ "-X github.com/mzz2017/gg/cmd.Version=${version}" "-s" "-w" "-buildid=" ];
  vendorSha256 = "sha256-MJMOCUIosLT9XhRsahQMx4Kq6j/aqCjhPq0ZvJc/Soc=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "A command-line tool for one-click proxy in your research and development without installing v2ray or anything else";
    homepage = "https://github.com/mzz2017/gg";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ xyenon ];
    mainProgram = "gg";
    platforms = platforms.linux;
  };
}
