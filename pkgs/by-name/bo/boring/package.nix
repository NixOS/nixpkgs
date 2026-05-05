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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "alebeck";
    repo = "boring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ei2Kl2590DY0S9jrc+MxsL5srxmwx8wD6uFlVQ6o4o=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "cmd/boring" ];

  vendorHash = "sha256-4YU0l2YhlMQzcKSMhXt3oEeCk87Yu90esiPelRs5/OQ=";

  ldflags = [
    "-s"
    "-w"
    "-X internal/buildinfo.Version=${finalAttrs.version}"
    "-X internal/buildinfo.Commit=${builtins.substring 0 5 finalAttrs.src.hash}"
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
