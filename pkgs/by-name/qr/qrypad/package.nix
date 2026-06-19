{
  lib,
  fetchFromGitHub,
  buildGoModule,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "qrypad";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "wheelibin";
    repo = "qrypad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vr3xH4ny/Bmz90SjpznlPBckeHQCrxh2HJhORRm2NNU=";
  };

  vendorHash = "sha256-5YBBy1kp+FNJMGzuIQHBIzxo9P7u0Z2hAepkmszcevA=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/wheelibin/qrypad/internal/constants.Version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal SQL client for Postgres, MySQL and SQLite";
    homepage = "https://github.com/wheelibin/qrypad";
    changelog = "https://github.com/wheelibin/qrypad/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wheelibin ];
    mainProgram = "qrypad";
  };
})
