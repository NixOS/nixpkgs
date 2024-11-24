{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  libwebp,
}:
let
  version = "1.3.2";
in
rustPlatform.buildRustPackage {
  pname = "catppuccin-catwalk";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "catwalk";
    rev = "refs/tags/v${version}";
    hash = "sha256-Yj9xTQJ0eu3Ymi2R9fgYwBJO0V+4bN4MOxXCJGQ8NjU=";
  };

  cargoHash = "sha256-bx7AvzPoMJqPa+zcn139lH2zyF09EIz7FNHnh1g8wis=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [ libwebp ];

  postInstall = ''
    installShellCompletion --cmd catwalk \
      --bash <("$out/bin/catwalk" completion bash) \
      --zsh <("$out/bin/catwalk" completion zsh) \
      --fish <("$out/bin/catwalk" completion fish)
  '';

  doInstallCheck = !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.isElf;
  installCheckPhase = ''
    runHook preInstallCheck
    readelf -a $out/bin/catwalk | grep -F 'Shared library: [libwebp.so'
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/catppuccin/toolbox/tree/main/catwalk";
    description = "CLI for Catppuccin that takes in four showcase images and displays them all at once";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryanccn ];
    mainProgram = "catwalk";
  };
}
