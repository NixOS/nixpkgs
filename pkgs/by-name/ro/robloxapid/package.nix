{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "robloxapid";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "paradoxum-wikis";
    repo = "RobloxAPID";
    rev = "9e6d9e9bbd618cca7edb4ca55a9a71a6c7a8ceb2";
    sha256 = "00b9fpib48w1kpqnmrr0vr6ssdwr74nwb77c8gxy8sj18gbhf6g7";
  };

  vendorHash = "sha256-FTppGvJ8pY0jB9RK7KVX9SvT1W3cbvA/Efv3Fo0AK2w=";
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A daemon that bridges the Roblox API to Fandom wikis. (MediaWiki)";
    homepage = "https://github.com/paradoxum-wikis/RobloxAPID";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ t7ru ];
    platforms = lib.platforms.linux;
  };
}
