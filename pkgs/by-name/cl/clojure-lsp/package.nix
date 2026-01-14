{
  lib,
  stdenvNoCC,
  buildGraalvmNativeImage,
  fetchurl,
  fetchFromGitHub,
  writeScript,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  testers,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "clojure-lsp";
  version = "2025.11.28-12.47.43";

  src = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${finalAttrs.version}/clojure-lsp-standalone.jar";
    hash = "sha256-An7sTudpP2Ct32sYShNhgRsHgJJIN9H+sR5MlQ8i+7o=";
  };

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

  passthru.updateScript = writeScript "update-clojure-lsp" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts gnused jq nix

    set -eu -o pipefail
    source "${stdenvNoCC}/setup"

    old_version="$(nix-instantiate --strict --json --eval -A clojure-lsp.version | jq -r .)"
    latest_version="$(curl -s https://api.github.com/repos/clojure-lsp/clojure-lsp/releases/latest | jq -r .tag_name)"

    if [[ $latest_version == $old_version ]]; then
      echo "Already at latest version $old_version"
      exit 0
    fi

    old_jar_hash="$(nix-instantiate --strict --json --eval -A clojure-lsp.jar.drvAttrs.outputHash | jq -r .)"

    curl -o clojure-lsp-standalone.jar -sL "https://github.com/clojure-lsp/clojure-lsp/releases/download/$latest_version/clojure-lsp-standalone.jar"
    new_jar_hash="$(nix-hash --flat --type sha256 clojure-lsp-standalone.jar | xargs -n1 nix --extra-experimental-features nix-command hash convert --hash-algo sha256)"

    rm -f clojure-lsp-standalone.jar

    update-source-version clojure-lsp "$latest_version" "$new_jar_hash"
  '';

  meta = {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/clojure-lsp/clojure-lsp";
    changelog = "https://github.com/clojure-lsp/clojure-lsp/releases/tag/${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ericdallo ];
    mainProgram = "clojure-lsp";
  };
})
