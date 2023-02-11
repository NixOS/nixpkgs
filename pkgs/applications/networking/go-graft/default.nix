{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "go-graft";
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "mzz2017";
    repo = "gg";
    rev = "v${version}";
    sha256 = "sha256-zdOcQ/+WXS7pDfnvYdb/FDjMT3yJdwnS8DoH2MIDcDs=";
  };

  CGO_ENABLED = 0;

  ldflags = [ "-X github.com/mzz2017/gg/cmd.Version=${version}" "-s" "-w" "-buildid=" ];
  vendorHash = "sha256-kx94B1XIXWJOY9Y69lNb/sHWVjsuFuOXrdtJFJrUuAs=";
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
