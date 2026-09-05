{
  lib,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "panix";
  version = "0.9.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mihakrumpestar";
    repo = "panix";
    rev = "v${version}";
    hash = "sha256-1dHxDPJ76LGxqm8/5qoC8d63J6faPvj//FiUlj8jisg=";
  };

  subPackages = [ "cmd/panix" ];

  flags = [ "-trimpath" ];
  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  doCheck = false;

  vendorHash = "sha256-c+Qjn/RTZdSOFeqCaANBLaJl3zFeJYe7lIAve35rDkQ=";

  nativeBuildInputs =
    pkgs.lib.optionals (pkgs.stdenv.buildPlatform.canExecute pkgs.stdenv.hostPlatform)
      [
        pkgs.installShellFiles
      ];

  postInstall = pkgs.lib.optionalString (pkgs.stdenv.buildPlatform.canExecute pkgs.stdenv.hostPlatform) ''
    installShellCompletion --cmd panix \
      --bash <($out/bin/panix completion -c bash) \
      --fish <($out/bin/panix completion -c fish) \
      --zsh <($out/bin/panix completion -c zsh)
  '';

  meta = with lib; {
    description = "Universal Nix Deployment Orchestrator";
    homepage = "https://github.com/mihakrumpestar/panix";
    changelog = "https://github.com/mihakrumpestar/panix/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mihakrumpestar ];
    platforms = platforms.all;
    mainProgram = "panix";
  };
}
