{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "qbt_go";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ludviglundgren";
    repo = "qbittorrent-cli";
    tag = "v${version}";
    hash = "sha256-7d5z/+948tfxkrs/s9Zv9guCCEIOuZhE9P954N4TD/g=";
  };

  vendorHash = "sha256-we4iI4s8PvBak67lTZZ3jLThQ3bqBhkEh3QRGcQgH80=";

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
