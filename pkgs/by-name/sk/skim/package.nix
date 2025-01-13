{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  runtimeShell,
  rustPlatform,
  skim,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.15.7";

  outputs = [
    "out"
    "man"
    "vim"
  ];

  src = fetchFromGitHub {
    owner = "skim-rs";
    repo = "skim";
    tag = "v${version}";
    hash = "sha256-vUKHyrvCGtRKziUqgIbgVP7YdH+UW3PFBECV/mo5RxY=";
  };

  postPatch = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/skim.vim
  '';

  cargoHash = "sha256-/tfbhNlpx96jlzUYwbucXi+pk1IE2jqxgWYjNU+4mHg=";

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
    tests.version = testers.testVersion { package = skim; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command-line fuzzy finder written in Rust";
    homepage = "https://github.com/skim-rs/skim";
    changelog = "https://github.com/skim-rs/skim/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dywedir
      getchoo
    ];
    mainProgram = "sk";
  };
}
