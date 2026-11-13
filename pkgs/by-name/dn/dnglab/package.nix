{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dnglab";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = "dnglab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2I7VOJdeJP4NjSosUpRFyPGtbREDkJvJPXbXWImCgpQ=";
  };

  cargoHash = "sha256-BDhfxsd//SJvkiGjaFlZCPLCHFNV55GlzqAN1LDQQfE=";

  strictDeps = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = ''
    rm $out/bin/benchmark $out/bin/identify
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v([\\d.]+)" ];
  };

  meta = {
    description = "Camera RAW to DNG file format converter";
    homepage = "https://github.com/dnglab/dnglab";
    license = lib.licenses.lgpl21Only;
    changelog = "https://github.com/dnglab/dnglab/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ VlaDexa ];
    mainProgram = "dnglab";
  };
})
