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
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "go-musicfox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QZHuQAOnthSm7Kb82i3NUWTnKk+9OMHV5vzOU72inX0=";
  };

  deleteVendor = true;

  vendorHash = "sha256-6DeoxpjVfykBI3fJAJpMZwJ4VTooIbxGpk5+SW198hU=";

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
