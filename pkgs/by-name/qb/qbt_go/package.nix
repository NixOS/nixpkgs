{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "qbt_go";
  version = "2.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ludviglundgren";
    repo = "qbittorrent-cli";
    tag = "v${version}";
    hash = "sha256-T2U7DP1LsRv1PJwsA3tl2gkUONZ/g/l/eulhSMBp4OQ=";
  };

  vendorHash = "sha256-x9WarAz+EQ4PDn1+tRNzhMoNvmP6BuMf7fylLsR2JCQ=";

  postPatch = ''
    substituteInPlace cmd/root.go \
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
