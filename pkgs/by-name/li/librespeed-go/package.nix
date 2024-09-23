{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  version = "1.1.5";
  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-ywGrodl/mj/WB25F0TKVvaV0PV4lgc+KEj0x/ix9HT8=";
  };
in
buildGoModule {
  pname = "librespeed-go";
  inherit version src;

  vendorHash = "sha256-ev5TEv8u+tx7xIvNaK8b5iq2XXF6I37Fnrr8mb+N2WM=";

  ldflags = [
    "-w"
    "-s"
  ];

  postInstall = ''
    cp -r web/assets $out/
  '';

  meta = {
    description = "A very lightweight speed test implementation in Go";
    homepage = "https://github.com/librespeed/speedtest-go";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ snaki ];
    mainProgram = "speedtest";
  };
}
