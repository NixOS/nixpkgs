{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, flac
, stdenv
, alsa-lib
, nix-update-script
}:

buildGoModule rec {
  pname = "go-musicfox";
  version = "4.5.3";

  src = fetchFromGitHub {
    owner = "go-musicfox";
    repo = "go-musicfox";
    rev = "v${version}";
    hash = "sha256-qf4XAAfWWlHAnNGhXaYpnjj+2z+/lWOHaTyv8R4UDgQ=";
  };

  deleteVendor = true;

  vendorHash = "sha256-oz/kVp/Jj2Lmo19UFOn2VPD/iWbSRCbmKy8fK8RdkYs=";

  subPackages = [ "cmd/musicfox.go" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-musicfox/go-musicfox/internal/types.AppVersion=${version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    flac
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Terminal netease cloud music client written in Go";
    homepage = "https://github.com/anhoder/go-musicfox";
    license = licenses.mit;
    mainProgram = "musicfox";
    maintainers = with maintainers; [ zendo Ruixi-rebirth aleksana ];
  };
}
