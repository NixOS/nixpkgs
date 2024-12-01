{
  lib,
  stdenv,
  fetchCrate,
  installShellFiles,
  nix-update-script,
  runtimeShell,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.10.4";

  outputs = [
    "out"
    "man"
    "vim"
  ];

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-C2yK+SO8Tpw3BxXXu1jeDzYJ2548RZa7NFWaE0SdNJ0=";
  };

  postPatch = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/skim.vim
  '';

  cargoHash = "sha256-jBcgoWbmBOgU7M71lr4OXOe2S6NAXl+I8D+ZtT45Vos=";

  nativeBuildInputs = [ installShellFiles ];

  postBuild = ''
    cat <<SCRIPT > sk-share
    #! ${runtimeShell}
    # Run this script to find the skim shared folder where all the shell
    # integration scripts are living.
    echo $out/share/skim
    SCRIPT
  '';

  postInstall = ''
    installBin bin/sk-tmux
    install -D -m 444 plugin/skim.vim -t $vim/plugin
    install -D -m 444 shell/* -t $out/share/skim

    installBin sk-share
    installManPage $(find man -type f)
  '';

  # Doc tests are broken on aarch64
  # https://github.com/lotabout/skim/issues/440
  cargoTestFlags = lib.optional stdenv.hostPlatform.isAarch64 "--all-targets";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command-line fuzzy finder written in Rust";
    homepage = "https://github.com/lotabout/skim";
    changelog = "https://github.com/skim-rs/skim/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "sk";
  };
}
