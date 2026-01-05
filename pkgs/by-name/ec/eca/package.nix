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
  pname = "eca";
  version = "0.94.1";

  src = fetchurl {
    url = "https://github.com/editor-code-assistant/eca/releases/download/${finalAttrs.version}/eca.jar";
    hash = "sha256-bbrmUgyPYWllFYYsp+GYhqRwWi5Do4aDbLHYazkdiDw=";
  };

  extraNativeImageBuildArgs = [
    # These build args mirror the build.clj upstream
    # ref: https://github.com/editor-code-assistant/eca/blob/0.93.2/build.clj#L84-L86
    "--no-fallback"
    "--native-image-info"
    "--features=clj_easy.graal_build_time.InitClojureClasses"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  passthru.updateScript = writeScript "update-eca" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts gnused jq nix

    set -eu -o pipefail
    source "${stdenvNoCC}/setup"

    old_version="$(nix-instantiate --strict --json --eval -A eca.version | jq -r .)"
    latest_version="$(curl -s https://api.github.com/repos/editor-code-assistant/eca/releases/latest | jq -r .tag_name)"

    if [[ $latest_version == $old_version ]]; then
      echo "Already at latest version $old_version"
      exit 0
    fi

    old_jar_hash="$(nix-instantiate --strict --json --eval -A eca.jar.drvAttrs.outputHash | jq -r .)"

    curl -o eca.jar -sL "https://github.com/editor-code-assistant/eca/releases/download/$latest_version/eca.jar"
    new_jar_hash="$(nix-hash --flat --type sha256 eca.jar | xargs -n1 nix --extra-experimental-features nix-command hash convert --hash-algo sha256)"

    rm -f eca.jar

    update-source-version eca "$latest_version" "$new_jar_hash"
  '';

  meta = with lib; {
    description = "AI pair programming capabilities agnostic of editor";
    homepage = "https://eca.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ crimeminister ];
    platforms = platforms.unix;
    mainProgram = "eca";
  };
})
