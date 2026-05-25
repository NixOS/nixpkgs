{
  boring,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "boring";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "alebeck";
    repo = "boring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cyRy7lF2wGupzDnW4zPKEuM0X0aaHrWbF/3p13xb2DA=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "cmd/boring" ];

  vendorHash = "sha256-4YU0l2YhlMQzcKSMhXt3oEeCk87Yu90esiPelRs5/OQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/alebeck/boring/internal/buildinfo.Version=${finalAttrs.version}"
    "-X github.com/alebeck/boring/internal/buildinfo.Commit=${
      builtins.substring 0 5 finalAttrs.src.rev
    }"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd boring      \
      --bash <($out/bin/boring --shell bash) \
      --fish <($out/bin/boring --shell fish) \
      --zsh  <($out/bin/boring --shell zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = boring;
      command = "boring version";
      version = "boring ${finalAttrs.version}";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "SSH tunnel manager";
    homepage = "https://github.com/alebeck/boring";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jacobkoziej
    ];
    mainProgram = "boring";
  };
})
