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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "alebeck";
    repo = "boring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lz5t3zLrswNqeASZKkMftVWKLTVHk/VJ7T+6rNY3oVQ=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "cmd/boring" ];

  vendorHash = "sha256-lEh2cE8IRZ5/oPRhfwvDySjm3Jlof/chaO3C39ouAnk=";

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
