{
  lib,
  stdenv,
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "rospo";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "ferama";
    repo = "rospo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+SeNpP/JplHvqT3kJwBCddJRaSwsJ/gyt/3mvVThNA0=";
  };

  vendorHash = "sha256-2Ldyh8RFRk/kCfj1Dv+KBBsEZDKOIgfGwyWV8UkqaDg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ferama/rospo/cmd.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall =
    let
      rospoBin =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.rospo;
    in
    ''
      installShellCompletion --cmd rospo \
        --bash <(${rospoBin}/bin/rospo completion bash) \
        --fish <(${rospoBin}/bin/rospo completion fish) \
        --zsh <(${rospoBin}/bin/rospo completion zsh)
    '';

  meta = {
    description = "Simple, reliable, persistent ssh tunnels with embedded ssh server";
    homepage = "https://github.com/ferama/rospo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "rospo";
  };
})
