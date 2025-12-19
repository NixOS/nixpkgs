{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "intermodal";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "casey";
    repo = "intermodal";
    rev = "v${version}";
    hash = "sha256-N3TumAwHcHDuVyY4t6FPNOO28D7xX5jheCTodfn71/Q=";
  };

  cargoHash = "sha256-NqbsDi47AhYw4hNcoWfXNUnc7WjC1en7mbyCJvhYdR4=";

  # include_hidden test tries to use `chflags` on darwin
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=subcommand::torrent::create::tests::include_hidden"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd imdl \
      --bash <($out/bin/imdl completions bash) \
      --fish <($out/bin/imdl completions fish) \
      --zsh  <($out/bin/imdl completions zsh)
  '';

  meta = {
    description = "User-friendly and featureful command-line BitTorrent metainfo utility";
    homepage = "https://github.com/casey/intermodal";
    changelog = "https://github.com/casey/intermodal/releases/tag/v${version}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [
      xrelkd
    ];
    mainProgram = "imdl";
  };
}
