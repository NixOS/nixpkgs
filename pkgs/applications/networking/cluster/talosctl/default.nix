{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
let
  # look for GO_LDFLAGS getting set in the Makefile
  version = "1.1.0";
  sha256 = "sha256-52WzQ5LWgIX/XBJPNvWV0tAPnw1AiINDL/7D3UYvvn4=";
  vendorSha256 = "sha256-iluI4UGw5cZ70wmC9jDiGttvxZ7xFyqcL9IZX4ubJqs=";
  pkgsVersion = "v1.1.0-8-gfa9a488";
  extrasVersion = "v1.1.0-1-g5800284";
in
buildGoModule rec {
  pname = "talosctl";
  inherit version vendorSha256;
  # nixpkgs-update: no auto update

  # disable workspace mode
  GOWORK = "off";

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
