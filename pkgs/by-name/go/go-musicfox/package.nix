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

buildGoModule (finalAttrs: {
  pname = "go-musicfox";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "go-musicfox";
    repo = "go-musicfox";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9OQTwyEGuHOMM5LgL6Y5zVavNnQhzJSZZu4ABhr0rds=";
  };

  deleteVendor = true;

  vendorHash = "sha256-MEcdWJts7hzt8fuhVsxHl1mQ57R8vNd3H3Tmpx4A9a4=";

  subPackages = [ "cmd/musicfox.go" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-musicfox/go-musicfox/internal/types.AppVersion=${finalAttrs.version}"
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
})
