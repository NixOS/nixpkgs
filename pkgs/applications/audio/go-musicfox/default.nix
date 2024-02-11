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
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "go-musicfox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JDR3D3tILT0q9jqcZmbfQC3yn7cmaSL/GEpCguqCFXI=";
  };

  deleteVendor = true;

  vendorHash = "sha256-ILO4v4ii1l9JokXG7R3vuN7i5hDi/hLHTFiClA2vdf0=";

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
