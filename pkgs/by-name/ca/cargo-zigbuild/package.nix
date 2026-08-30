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
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-zigbuild";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Woa8lcx9D5U2NyxHqLE9nIkgtvLc35lo+H+Cp+NOHKg=";
  };

  cargoHash = "sha256-Q/Hf9fHxA/3EhnbWapyMak4nyZt/5HTL8osE7Nit6g0=";

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
