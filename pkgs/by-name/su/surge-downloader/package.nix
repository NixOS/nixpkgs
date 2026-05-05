{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "surge-downloader";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "surge-downloader";
    repo = "surge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zI2eCVvj+u16mQstdL9yY0eVSj2YIGRGHlmsbRHoPXA=";
  };

  vendorHash = "sha256-zaQPmtzGfdj959Mi0Zt1R097XkZFbtJspcYry4SkpEg=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/surge-downloader/surge/cmd.Version=${finalAttrs.version}"
    "-X=github.com/surge-downloader/surge/cmd.BuildTime=1970-01-01T00:00:00Z"
  ];

  # Workaround for a test that requires the root path /homeless-shelter to be writeable
  postPatch = ''
    substituteInPlace internal/utils/debug_test.go \
    --replace-fail 'logsDir := config.GetLogsDir()' 'logsDir := config.GetLogsDir(); if v := os.Getenv("TMPDIR"); v != "" { logsDir = filepath.Join(v, "surge-logs") }'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blazing fast TUI download manager built in Go for power users";
    homepage = "https://github.com/surge-downloader/surge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crispyfires ];
    mainProgram = "surge";
  };
})
