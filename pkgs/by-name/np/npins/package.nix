{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,

  # runtime dependencies
  nix-prefetch-git,
  nix-prefetch-docker,
  git, # for git ls-remote
}:

let
  runtimePath = lib.makeBinPath [
    nix-prefetch-git
    nix-prefetch-docker
    git
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npins";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "andir";
    repo = "npins";
    tag = finalAttrs.version;
    sha256 = "sha256-OkPEh0axWs3gUoUyplQexYpEXxyCDYWm5BQpwB2PIqA=";
  };

  cargoHash = "sha256-ZbdAvt2FRq5fHS0RRndeCrpY3j8Lvn2oTAECteIss5A=";

  cargoBuildFlags = [
    "-p"
    "npins"
    "-p"
    "npins-completions"
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  # (Almost) all tests require internet
  doCheck = false;

  postFixup =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd npins \
        --bash <($out/bin/npins-completions bash) \
        --fish <(cat <($out/bin/npins-completions fish) $src/completions/pin-completions.fish) \
        --zsh <($out/bin/npins-completions zsh)

      rm $out/bin/npins-completions
    ''
    + ''
      wrapProgram $out/bin/npins --prefix PATH : "${runtimePath}"
    '';

  meta = {
    description = "Simple and convenient dependency pinning for Nix";
    mainProgram = "npins";
    homepage = "https://github.com/andir/npins";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      piegames
      coca
    ];
  };
})
