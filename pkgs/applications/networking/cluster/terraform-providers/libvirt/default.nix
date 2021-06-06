{ lib, buildGoPackage, fetchFromGitHub, fetchpatch, libvirt, pkg-config, makeWrapper, cdrtools }:

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
  pname = "terraform-provider-libvirt";
  version = "0.6.3";

  goPackagePath = "github.com/dmacvicar/terraform-provider-libvirt";

  patches = [
    (fetchpatch {
      name = "base_volume_copy.patch";
      url = "https://github.com/cyril-s/terraform-provider-libvirt/commit/52df264e8a28c40ce26e2b614ee3daea882931c3.patch";
      sha256 = "1fg7ii2fi4c93hl41nhcncy9bpw3avbh6yiq99p1vkf87hhrw72n";
    })
  ];

  src = fetchFromGitHub {
    owner = "dmacvicar";
    repo = "terraform-provider-libvirt";
    rev = "v${version}";
    sha256 = "0ak2lpnv6h0i7lzfcggd90jpfhvsasdr6nflkflk2drlcpalggj9";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ libvirt ];

  # mkisofs needed to create ISOs holding cloud-init data,
  # and wrapped to terraform via deecb4c1aab780047d79978c636eeb879dd68630
  propagatedBuildInputs = [ cdrtools ];

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-libvirt{,_v${version}}";

  meta = with lib; {
    homepage = "https://github.com/dmacvicar/terraform-provider-libvirt";
    description = "Terraform provider for libvirt";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
  };
}
