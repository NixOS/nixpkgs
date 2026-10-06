{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pfetch";
  version = "1.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Un1q32";
    repo = "pfetch";
    tag = finalAttrs.version;
    hash = "sha256-QxHbk27A45awUqLGS/HZmOLOi0sQ1DVfwCFhyOlSCKk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin pfetch

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Pretty system information tool written in POSIX sh";
    homepage = "https://github.com/Un1q32/pfetch";
    changelog = "https://github.com/Un1q32/pfetch/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      equirosa
      phanirithvij
    ];
    mainProgram = "pfetch";
  };
})
