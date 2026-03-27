{
  fetchFromCodeberg,
  installShellFiles,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codeberg-cli";
  version = "0.5.5";

  src = fetchFromCodeberg {
    owner = "Aviac";
    repo = "codeberg-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yjWAL4Tu9nuQsy8fDhga5lsxYwooE0fW70zfp7Dqq3Y=";
  };

  cargoHash = "sha256-AD4VLGsxkfl1UwJmZhR183Gk7ltjEyH9tlt+iKNs5J0=";
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ openssl ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd berg \
      --bash <($out/bin/berg completion bash) \
      --fish <($out/bin/berg completion fish) \
      --zsh <($out/bin/berg completion zsh)
  '';

  meta = {
    description = "CLI Tool for Codeberg similar to gh and glab";
    homepage = "https://codeberg.org/Aviac/codeberg-cli";
    license = with lib.licenses; [ agpl3Plus ];
    maintainers = with lib.maintainers; [ robwalt ];
    mainProgram = "berg";
  };
})
