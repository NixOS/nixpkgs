{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "manix";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "manix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hniN0mc7Ud+5zDlOuf2F+/DKrtQ6grZF74ej0L6gMso=";
  };

  cargoHash = "sha256-FTrKdOuXTOqr7on4RzYl/UxgUJqh+Rk3KJXqsW0fuo0=";

  nativeBuildInputs = [ installShellFiles ];

  # --generate and --print-man still require the positional QUERY argument
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd manix \
      --bash <($out/bin/manix --generate bash "") \
      --fish <($out/bin/manix --generate fish "") \
      --zsh <($out/bin/manix --generate zsh "")
    $out/bin/manix --print-man "" > manix.1
    installManPage manix.1
  '';

  meta = {
    description = "Fast CLI documentation searcher for Nix";
    homepage = "https://github.com/nix-community/manix";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      lecoqjacob
      iogamaster
    ];
    mainProgram = "manix";
  };
})
