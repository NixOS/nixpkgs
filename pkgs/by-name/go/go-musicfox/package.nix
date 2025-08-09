{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  flac,
  stdenv,
  alsa-lib,
  nix-update-script,
}:

buildGoModule rec {
  pname = "go-musicfox";
  version = "4.6.3";

  src = fetchFromGitHub {
    owner = "go-musicfox";
    repo = "go-musicfox";
    rev = "v${version}";
    hash = "sha256-TxBd+Q7tEyJpcUwOWAl2U1gmdNRYrBkGCtT961/8K1E=";
  };

  deleteVendor = true;

  vendorHash = "sha256-RK0mBnRzh9cbqrdJHQk5eJPREFDKGbjnQyEIF23xrvU=";

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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal netease cloud music client written in Go";
    homepage = "https://github.com/anhoder/go-musicfox";
    license = lib.licenses.mit;
    mainProgram = "musicfox";
    maintainers = with lib.maintainers; [
      zendo
      Ruixi-rebirth
      aleksana
    ];
  };
}
