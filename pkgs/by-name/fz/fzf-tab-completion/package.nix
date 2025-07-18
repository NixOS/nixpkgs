{
  fetchFromGitHub,
  fzf,
  gawk,
  gnugrep,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "fzf-tab-completion";
  version = "0-unstable-2025-01-20";

  src = fetchFromGitHub {
    owner = "lincheney";
    repo = "fzf-tab-completion";
    rev = "4850357beac6f8e37b66bd78ccf90008ea3de40b";
    hash = "sha256-pgcrRRbZaLoChVPeOvw4jjdDCokUK1ew0Wfy42bXfQo=";
  };

  sourceRoot = "source/readline/";
  cargoHash = "sha256-Y9zQej5tW3DkptwnqdxxJTFgh1RL/r8xZultCoz0nYg=";

  strictDeps = true;

  buildInputs = [
    fzf
    gawk
    gnugrep
  ];

  postInstall = ''
    pushd ..
    install -Dt $out/bin/ readline/bin/rl_custom_complete
    install -Dt $out/share/fzf-tab-completion \
      bash/fzf-bash-completion.sh \
      node/fzf-node-completion.js \
      python/fzf_python_completion.py \
      zsh/fzf-zsh-completion.sh
    popd
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Tab completion using fzf";
    homepage = "https://github.com/lincheney/fzf-tab-completion";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.bmrips ];
    platforms = lib.platforms.linux;
  };
}
