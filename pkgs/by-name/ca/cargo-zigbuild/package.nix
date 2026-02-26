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
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "messense";
    repo = "cargo-zigbuild";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t96yIRfXLGN92xoygl32Q1rpsebySdOsrmkwQ5zH5xQ=";
  };

  cargoHash = "sha256-HOzkO81xVcKwe4ySe1IkOYcX5i1Un0mGNX7824/eh0k=";

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
    homepage = "https://github.com/messense/cargo-zigbuild";
    changelog = "https://github.com/messense/cargo-zigbuild/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
