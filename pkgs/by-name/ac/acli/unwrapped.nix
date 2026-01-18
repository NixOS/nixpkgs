{
  lib,
  stdenvNoCC,
  fetchurl,
  versionCheckHook,
  installShellFiles,

  writeShellApplication,
  curl,
  gnugrep,
  common-updater-scripts,

  pname ? "acli-unwrapped",
  src,
  version,
  meta,
  updateScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit
    pname
    src
    version
    meta
    ;

  dontBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -Dm755 acli $out/bin/acli
  ''
  + lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd acli \
      --bash <($out/bin/acli completion bash) \
      --fish <($out/bin/acli completion fish) \
      --zsh <($out/bin/acli completion zsh)

    mkdir -p $out/share/powershell
    $out/bin/acli completion powershell > $out/share/powershell/acli.Completion.ps1
  ''
  + ''
    runHook postInstall
  '';

  passthru = {
    inherit updateScript;
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

})
