{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "clojure-lsp";
  version = "2026.10.15-11.42.38";

  src = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${finalAttrs.version}/clojure-lsp-standalone.jar";
    hash = "sha256-ttTVSxtTvq93G3kfjZ+M/qa7YTrg3zNwiebXOHGOF5s=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  extraNativeImageBuildArgs = [
    # These build args mirror the build.clj upstream
    # ref: https://github.com/clojure-lsp/clojure-lsp/blob/2024.08.05-18.16.00/cli/build.clj#L141-L144
    "--no-fallback"
    "--native-image-info"
    "--features=clj_easy.graal_build_time.InitClojureClasses"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/clojure-lsp/clojure-lsp";
    changelog = "https://github.com/clojure-lsp/clojure-lsp/releases/tag/${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ericdallo
      jlesquembre
    ];
    mainProgram = "clojure-lsp";
  };
})
