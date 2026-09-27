{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  stdenvNoCC,
  withReadlineSupport ? !stdenvNoCC.hostPlatform.isAarch,
}:

let
  drvArgs = {
    pname = "fzf-tab-completion";
    version = "0-unstable-2026-01-31";

    src = fetchFromGitHub {
      owner = "lincheney";
      repo = "fzf-tab-completion";
      rev = "7014e0a7cd68fe3530e2f58c45740d17e98f05b8";
      hash = "sha256-qxHvd91QOv4LATikWGaL4AqEM52volP8TCYXhpZKtsA=";
    };

    __structuredAttrs = true;
    strictDeps = true;

    postInstall = ''
      install -Dt $out/share/fzf-tab-completion \
        bash/fzf-bash-completion.sh \
        node/fzf-node-completion.js \
        python/fzf_python_completion.py \
        zsh/fzf-zsh-completion.sh
    '';

    passthru.updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };

    meta = {
      description = "Tab completion using fzf";
      homepage = "https://github.com/lincheney/fzf-tab-completion";
      license = lib.licenses.gpl3Only;
      maintainers = [ lib.maintainers.bmrips ];
      platforms = lib.platforms.all;
    };
  };
in

if !withReadlineSupport then
  stdenvNoCC.mkDerivation drvArgs
else
  rustPlatform.buildRustPackage (
    drvArgs
    // {
      sourceRoot = "source/readline/";
      cargoHash = "sha256-Y9zQej5tW3DkptwnqdxxJTFgh1RL/r8xZultCoz0nYg=";
      postInstall = ''
        env -C .. install -Dt $out/bin/ readline/bin/rl_custom_complete
        env -C .. ${drvArgs.postInstall}
      '';
    }
  )
