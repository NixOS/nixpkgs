{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_13,
  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bold";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kubkon";
    repo = "bold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7sn/8SIoT/JGdza8SpX+8usiVhqugVVMaLU1a1oMdj8=";
  };

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig_0_13.hook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "-v" ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Drop-in replacement for Apple system linker ld";
    homepage = "https://github.com/kubkon/bold";
    changelog = "https://github.com/kubkon/bold/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = lib.platforms.darwin;
    mainProgram = "bold";
  };
})
