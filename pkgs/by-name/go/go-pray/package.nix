{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  alsa-lib,
}:

buildGoModule (finalAttrs: {
  pname = "go-pray";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "0xzer0x";
    repo = "go-pray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wi/sUjzNbVLbqwtM1BglmXgkaqMamjIsGS6EjlyeC9Y=";
  };

  vendorHash = "sha256-qMTg2Vsk0nte1O8sbNWN5CCCpgpWLvcb2RuGMoEngYE=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ alsa-lib ];

  ldflags = [
    "-X github.com/0xzer0x/go-pray/internal/version.version=${finalAttrs.version}"
    "-X github.com/0xzer0x/go-pray/internal/version.buildTime=1980-01-01T00:00:00Z"
  ];

  # NOTE: Create temporary config file to supress missing config error
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    printf 'calculation: { method: "UAQ" }\nlocation: { lat: 0, long: 0 }\n' > tmpconfig.yml
    installShellCompletion --cmd go-pray \
      --bash <($out/bin/go-pray --config=tmpconfig.yml completion bash) \
      --fish <($out/bin/go-pray --config=tmpconfig.yml completion fish) \
      --zsh <($out/bin/go-pray --config=tmpconfig.yml completion zsh)
    rm tmpconfig.yml
  '';

  meta = {
    description = "Prayer times CLI to remind you to Go pray";
    homepage = "https://github.com/0xzer0x/go-pray";
    changelog = "https://github.com/0xzer0x/go-pray/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ _0xzer0x ];
    platforms = lib.platforms.linux;
    mainProgram = "go-pray";
  };
})
