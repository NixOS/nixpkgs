{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule {
  pname = "qbt_go";
  version = "2.2.0-unstable-2026-05-11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ludviglundgren";
    repo = "qbittorrent-cli";
    # tag = "v${version}";
    rev = "7f9095d28f28a7dd4ef3c7b8cc53266f4c55edb7";
    hash = "sha256-BpvvU5WSxYLvraXAPzz8wgZ3m9L+MCwaSgJbgTMK3jY=";
  };

  vendorHash = "sha256-fcLuFZrJV4qjLWxI/aq2dnn4A1WxHm63fcD/TARFtxY=";

  postPatch = ''
    substituteInPlace cmd/qbt/main.go \
      --replace-fail 'Use:   "qbt"' 'Use:   "qbt_go"'
    mv cmd/qbt cmd/qbt_go
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd qbt_go \
      --bash <($out/bin/qbt_go completion bash) \
      --zsh <($out/bin/qbt_go completion zsh) \
      --fish <($out/bin/qbt_go completion fish)
  '';

  meta = {
    description = "Cli to manage qBittorrent";
    homepage = "https://github.com/ludviglundgren/qbittorrent-cli";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ chungyinleo ];
    mainProgram = "qbt_go";
  };
}
