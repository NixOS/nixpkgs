{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "talosctl";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "talos-systems";
    repo = "talos";
    rev = "v${version}";
    sha256 = "sha256-JeZ+Q6LTDJtoxfu4mJNc3wv3Y6OPcIUvgnozj9mWwLw=";
  };

  vendorSha256 = "sha256-ujbEWvcNJJOUegVgAGEPwYF02TiqD1lZELvqc/Gmb4A=";

  # look for GO_LDFLAGS getting set in the Makefile
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
      "-X ${versionPkg}.PkgsVersion=v0.9.0-2-g447ce75" # PKGS
      "-X ${versionPkg}.ExtrasVersion=v0.7.0-1-gd6b73a7" # EXTRAS
      "-X ${imagesPkgs}.Username=talos-systems" # USERNAME
      "-X ${imagesPkgs}.Registry=ghcr.io" # REGISTRY
      "-X ${mgmtHelpersPkg}.ArtifactsPath=_out" # ARTIFACTS
    ];

  subPackages = [ "cmd/talosctl" ];

  doCheck = false;

  meta = with lib; {
    description = "A CLI for out-of-band management of Kubernetes nodes created by Talos";
    homepage = "https://github.com/talos-systems/talos";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flokli ];
  };
}
