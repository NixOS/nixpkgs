{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "goshs";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "patrickhener";
    repo = "goshs";
    tag = "v${version}";
    hash = "sha256-J74nUH3iBYDytXCswIexvShG5+zJEDX19saJ3ftLYhI=";
  };

  vendorHash = "sha256-6UaKh2UUyGqOriAaMhiEFr20R4W/ZWxQXtXnm/BVHOc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Simple, yet feature-rich web server written in Go";
    homepage = "https://goshs.de";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    # --- FAIL: TestGetIPv4Addr (0.00s)
    #     utils_test.go:62: route ip+net: no such network interface
    badPlatforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ seiarotg ];
    mainProgram = "goshs";
  };
}
