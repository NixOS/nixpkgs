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
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "go-musicfox";
    repo = "go-musicfox";
    rev = "v${version}";
    hash = "sha256-pzB57XeDD8lfJMkP9/k1rrszYXYYzQt2UekH2Atiqjw=";
  };

  deleteVendor = true;

  vendorHash = "sha256-IO/UlOW6pLZp6JaU5P9vUJ0qx0Srvmb5vjpX1pSdaeM=";

  subPackages = [ "cmd/musicfox.go" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-musicfox/go-musicfox/internal/types.AppVersion=${version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
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
