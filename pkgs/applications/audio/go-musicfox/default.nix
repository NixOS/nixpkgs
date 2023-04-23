{ lib
, fetchFromGitHub
, buildGoModule
, clangStdenv
, pkg-config
, alsa-lib
, flac
}:

# gcc only supports objc on darwin
buildGoModule.override { stdenv = clangStdenv; } rec {
  pname = "go-musicfox";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "anhoder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NAAl/XmJqRnJyOYNJqmMlCIiGsCsSH7gGTMbD46gpss=";
  };

  deleteVendor = true;

  vendorHash = null;

  subPackages = [ "cmd/musicfox.go" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-musicfox/go-musicfox/pkg/constants.AppVersion=${version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    flac
  ];

  meta = with lib; {
    description = "Terminal netease cloud music client written in Go";
    homepage = "https://github.com/anhoder/go-musicfox";
    license = licenses.mit;
    mainProgram = "musicfox";
    maintainers = with maintainers; [ zendo Ruixi-rebirth ];
  };
}
