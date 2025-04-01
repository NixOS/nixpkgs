{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "go-graft";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "mzz2017";
    repo = "gg";
    rev = "v${version}";
    sha256 = "sha256-DXW0NtFYvcCX4CgMs5/5HPaO9f9eFtw401wmJdCbHPU=";
  };

  CGO_ENABLED = 0;

  ldflags = [
    "-X github.com/mzz2017/gg/cmd.Version=${version}"
    "-s"
    "-w"
  ];
  vendorHash = "sha256-fnM4ycqDyruCdCA1Cr4Ki48xeQiTG4l5dLVuAafEm14=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Command-line tool for one-click proxy in your research and development without installing v2ray or anything else";
    homepage = "https://github.com/mzz2017/gg";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ xyenon ];
    mainProgram = "gg";
    platforms = platforms.linux;
  };
}
