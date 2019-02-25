{ stdenv, buildGoPackage, fetchFromGitHub, libvirt, pkgconfig, makeWrapper, cdrtools }:

# USAGE:
# install the following package globally or in nix-shell:
#
#   (terraform.withPlugins (p: [p.libvirt]))
#
# configuration.nix:
#
#   virtualisation.libvirtd.enable = true;
#
# terraform-provider-libvirt does not manage pools at the moment:
#
#   $ virsh --connect "qemu:///system" pool-define-as default dir - - - - /var/lib/libvirt/images
#   $ virsh --connect "qemu:///system" pool-start default
#
# pick an example from (i.e ubuntu):
# https://github.com/dmacvicar/terraform-provider-libvirt/tree/master/examples

buildGoPackage rec {
  name = "terraform-provider-libvirt-${version}";
  version = "0.5.1";

  goPackagePath = "github.com/dmacvicar/terraform-provider-libvirt";

  src = fetchFromGitHub {
    owner = "dmacvicar";
    repo = "terraform-provider-libvirt";
    rev = "v${version}";
    sha256 = "0shnj5byqj3qzyqniiy1dcygd8xw1h2bx9z6mgcydw8k64fkm4bw";
  };

  buildInputs = [ libvirt pkgconfig makeWrapper ];

  # mkisofs needed to create ISOs holding cloud-init data,
  # and wrapped to terraform via deecb4c1aab780047d79978c636eeb879dd68630
  propagatedBuildInputs = [ cdrtools ];

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-libvirt{,_v${version}}";

  meta = with stdenv.lib; {
    homepage = https://github.com/dmacvicar/terraform-provider-libvirt;
    description = "Terraform provider for libvirt";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
  };
}

