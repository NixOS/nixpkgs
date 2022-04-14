{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
let
  # look for GO_LDFLAGS getting set in the Makefile
  version = "1.0.2";
  sha256 = "sha256-FcwbZAAPsZ1WkLOwXHNRAI1SrEv7JLSkIReCe/FNckQ=";
  vendorSha256 = "sha256-qDP2b0EAJzqpmAU1/Te9/tD8hm6zCF8B33yr0Z55WFU=";
  pkgsVersion = "v1.0.0-7-ge6eb485";
  extrasVersion = "v1.0.0-2-gc5d3ab0";
in
buildGoModule rec {
  pname = "talosctl";
  inherit version vendorSha256;
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "siderolabs";
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
      "-X ${versionPkg}.Name=Client"
      "-X ${versionPkg}.SHA=${src.rev}" # should be the hash, but as we build from tags, this needs to do
      "-X ${versionPkg}.Tag=${src.rev}"
      "-X ${versionPkg}.PkgsVersion=${pkgsVersion}" # PKGS
      "-X ${versionPkg}.ExtrasVersion=${extrasVersion}" # EXTRAS
      "-X ${imagesPkgs}.Username=siderolabs" # USERNAME
      "-X ${imagesPkgs}.Registry=ghcr.io" # REGISTRY
      "-X ${mgmtHelpersPkg}.ArtifactsPath=_out" # ARTIFACTS
      "-s"
      "-w"
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
    homepage = "https://www.talos.dev/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flokli ];
  };
}
