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
  version = "4.7.2";

  src = fetchFromGitHub {
    owner = "go-musicfox";
    repo = "go-musicfox";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RJPb+aZawU22HBXTfr7+TP0ocFsNrP1mOHvHPRm2RnA=";
  };

  deleteVendor = true;

  vendorHash = "sha256-KQp22eF48jhhCSZA/1weWVavyP3be4j4mOPM5EPssGs=";

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
