{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asdcontrol";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "omakasui";
    repo = "asdcontrol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kxzkZeoUZu3dUp/E95h5e8R/BMLakyIgoSug2j0jOR4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  makeFlags = [ "asdcontrol" ];

  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 asdcontrol $out/bin/asdcontrol
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Apple Studio Display and Pro Display XDR brightness control for Linux";
    homepage = "https://github.com/omakasui/asdcontrol";
    changelog = "https://github.com/omakasui/asdcontrol/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "asdcontrol";
  };
})
