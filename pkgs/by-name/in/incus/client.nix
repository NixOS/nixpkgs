{
  lts ? false,

  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  releaseFile = if lts then ./lts.nix else ./latest.nix;
  inherit (import releaseFile) version hash vendorHash;
in

buildGoModule rec {
  pname = "incus-client";

  inherit vendorHash version;

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "refs/tags/v${version}";
    inherit hash;
  };

  CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/incus" ];

  postInstall = ''
    # use custom bash completion as it has extra logic for e.g. instance names
    installShellCompletion --bash --name incus ./scripts/bash/incus

    installShellCompletion --cmd incus \
      --fish <($out/bin/incus completion fish) \
      --zsh <($out/bin/incus completion zsh)
  '';

  # don't run the full incus test suite
  doCheck = false;

  meta = {
    description = "Powerful system container and virtual machine manager";
    homepage = "https://linuxcontainers.org/incus";
    changelog = "https://github.com/lxc/incus/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.unix;
    mainProgram = "incus";
  };
}
