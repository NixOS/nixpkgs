{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  makeBinaryWrapper,
  nix-update-script,
  rust-jemalloc-sys,
  tsgolint,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxlint";
  version = "1.47.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxlint_v${finalAttrs.version}";
    hash = "sha256-fzM+sVCQmZkBfMbD/Ko6R2zwosgOe0xJWBgOKbJ26uY=";
  };

  cargoHash = "sha256-e5DqyFqK/imxEkRchycpDZp+7B1lXdsYJLzVNzzQ7Kw=";

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];
  buildInputs = [
    rust-jemalloc-sys
  ];

  env.OXC_VERSION = finalAttrs.version;

  cargoBuildFlags = [
    "--bin=oxlint"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  postFixup = ''
    wrapProgram $out/bin/oxlint \
      --prefix PATH : "${lib.makeBinPath [ tsgolint ]}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^oxlint_v([0-9.]+)$" ];
  };

  meta = {
    description = "Collection of JavaScript tools written in Rust";
    homepage = "https://github.com/oxc-project/oxc";
    changelog = "https://github.com/oxc-project/oxc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "oxlint";
  };
})
