{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  zig,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-zigbuild";
  version = "0.22.3";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-zigbuild";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f9jmt3UXniXVeX2NyuRx30DrpRtczLO7ZioNi4TI3Zk=";
  };

  cargoHash = "sha256-7ZQpAePAIqSNiKM8bTAhyx4QyDQda1J8TSnZX0W2tfY=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-zigbuild \
      --prefix PATH : ${zig}/bin
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to compile Cargo projects with zig as the linker";
    mainProgram = "cargo-zigbuild";
    homepage = "https://github.com/rust-cross/cargo-zigbuild";
    changelog = "https://github.com/rust-cross/cargo-zigbuild/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
