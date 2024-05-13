{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, alsa-lib
, flac
, nix-update-script
}:

buildGoModule rec {
  pname = "go-musicfox";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "go-musicfox";
    repo = "go-musicfox";
    rev = "v${version}";
    hash = "sha256-11N3dykuEDKAryieNVaPfb3G7E/a4A7Znx9rBvFTHC4=";
  };

  deleteVendor = true;

  vendorHash = "sha256-ey78zeCSEuRgteG5ZRb4uO88E6lwEgqSxKfjJg3NGT4=";

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
    alsa-lib
    flac
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
