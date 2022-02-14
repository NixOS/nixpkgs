{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
let
  # look for GO_LDFLAGS getting set in the Makefile
  version = "0.14.2";
  sha256 = "sha256-sQtry94T5cDO+836D/p/8ptQi3WYKDBLr1QZyEXdLQI=";
  vendorSha256 = "sha256-cd2iNMxWmkSWqqkPLYocUG+fCUXoeUXEuGQxjUWQnXk=";
  pkgsVersion = "0.9.0-4-gc875fbe";
  extrasVersion = "0.7.0-2-gb4c9d21";
in
buildGoModule rec {
  pname = "talosctl";
  inherit version vendorSha256;
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "talos-systems";
    repo = "talos";
    rev = "v${version}";
    inherit sha256;
  };

  ldflags =
    let
      versionPkg = "github.com/talos-systems/talos/pkg/version"; # VERSION_PKG
      imagesPkgs = "github.com/talos-systems/talos/pkg/images"; # IMAGES_PKGS
      mgmtHelpersPkg = "github.com/talos-systems/talos/cmd/talosctl/pkg/mgmt/helpers"; #MGMT_HELPERS_PKG
    in
    [
      "-X ${versionPkg}.Name=Talos"
      "-X ${versionPkg}.SHA=${src.rev}" # should be the hash, but as we build from tags, this needs to do
      "-X ${versionPkg}.Tag=${src.rev}"
      "-X ${versionPkg}.PkgsVersion=v${pkgsVersion}" # PKGS
      "-X ${versionPkg}.ExtrasVersion=v${extrasVersion}" # EXTRAS
      "-X ${imagesPkgs}.Username=talos-systems" # USERNAME
      "-X ${imagesPkgs}.Registry=ghcr.io" # REGISTRY
      "-X ${mgmtHelpersPkg}.ArtifactsPath=_out" # ARTIFACTS
    ];

  subPackages = [ "cmd/talosctl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd talosctl \
      --bash <($out/bin/talosctl completion bash) \
      --fish <($out/bin/talosctl completion fish) \
      --zsh <($out/bin/talosctl completion zsh)
  '';

  doCheck = false;

  meta = with lib; {
    description = "A CLI for out-of-band management of Kubernetes nodes created by Talos";
    homepage = "https://github.com/talos-systems/talos";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flokli ];
  };
}
