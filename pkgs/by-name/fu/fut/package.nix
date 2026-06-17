{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fut";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "fusionlanguage";
    repo = "fut";
    tag = "fut-${finalAttrs.version}";
    hash = "sha256-UOToKLQMO/g48DfXi9QQoZ7xJgBsz1Spjc35oEgjHis=";
  };

  buildPhase = ''
    runHook preBuild

    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp fut $out/bin/

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Fusion programming language";
    longDescription = ''
      Fusion is a programming language designed for implementing reusable components (libraries) for C, C++, C#, D, Java, JavaScript, Python, Swift, TypeScript and OpenCL C, all from a single codebase.
    '';
    homepage = "https://fusion-lang.org";
    changelog = "https://github.com/fusionlanguage/fut/releases/tag/fut-${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # require macos-26
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "fut";
  };
})
