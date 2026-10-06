{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "binmerge";
  version = "1.0.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "putnam";
    repo = "binmerge";
    tag = finalAttrs.version;
    hash = "sha256-83c7PUZvAplBy03z6BRP5kdruSk72yINMbYsM9wqzeI=";
  };

  buildInputs = [ python3 ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 binmerge -t $out/bin

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--license";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to merge multiple bin/cue tracks into one";
    homepage = "https://github.com/putnam/binmerge";
    changelog = "https://github.com/putnam/binmerge/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.all;
    mainProgram = "binmerge";
  };
})
