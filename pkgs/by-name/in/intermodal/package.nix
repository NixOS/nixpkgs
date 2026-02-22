{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "intermodal";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "casey";
    repo = "intermodal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dNDJHLxKsuAwQifNHTjr4qhPx+GGY0KUAeWz1qthqOo=";
  };

  cargoHash = "sha256-QYovc4oSnQgEwjPDjyKyoAdYy0XkRLa1K6aFn9yrX4o=";

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
    changelog = "https://github.com/casey/intermodal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [
      xrelkd
    ];
    mainProgram = "imdl";
  };
})
