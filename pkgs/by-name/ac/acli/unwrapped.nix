{
  stdenvNoCC,
  versionCheckHook,

  pname ? "acli-unwrapped",
  src,
  version,
  meta,
  updateScript,
}:
stdenvNoCC.mkDerivation {
  inherit
    pname
    src
    version
    meta
    ;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 acli $out/bin/acli

    runHook postInstall
  '';

  passthru = {
    inherit updateScript;
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;
}
