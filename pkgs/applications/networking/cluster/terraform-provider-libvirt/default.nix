{ stdenv, buildGoPackage, fetchFromGitHub, libvirt, pkgconfig, makeWrapper, cdrtools }:

# USAGE:
# install the following package globally or in nix-shell:
#
#   (terraform.withPlugins (old: [terraform-provider-libvirt]))
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
  version = "0.3";

  goPackagePath = "github.com/dmacvicar/terraform-provider-libvirt";

  src = fetchFromGitHub {
    owner = "dmacvicar";
    repo = "terraform-provider-libvirt";
    rev = "v${version}";
    sha256 = "004gxy55p5cf39f2zpah0i2zhvs4x6ixnxy8z9v7314604ggpkna";
  };

  buildInputs = [ libvirt pkgconfig makeWrapper ];

  goDeps = ./deps.nix;

  propagatedBuildInputs = [ cdrtools ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dmacvicar/terraform-provider-libvirt;
    description = "Terraform provider for libvirt";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
  };
}

