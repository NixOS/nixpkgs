{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sockstat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mezantrop";
    repo = "sockstat";
    tag = finalAttrs.version;
    hash = "sha256-7VfideKNWlWb9nnAL2TK7HiD0T5EJsQiagT2kPMwrdA=";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    installBin sockstat

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FreeBSD-like sockstat for macOS using libproc";
    homepage = "https://github.com/mezantrop/sockstat";
    changelog = "https://github.com/mezantrop/sockstat/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = lib.platforms.darwin;
    mainProgram = "sockstat";
  };
})
