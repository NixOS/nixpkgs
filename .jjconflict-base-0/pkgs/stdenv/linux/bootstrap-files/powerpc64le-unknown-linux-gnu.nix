#
# Files came from this Hydra build:
#
#   https://hydra.nixos.org/build/186237511
#
# Which used nixpkgs revision ac43c444780a80e789fd14fe2114acd4a3b5cf9d
# to instantiate:
#
#   /nix/store/nhjbza9vlcyhp9zxfz6lwpc3m2ghrpzj-stdenv-bootstrap-tools-powerpc64le-unknown-linux-gnu.drv
#
# and then built:
#
#   /nix/store/fklpm7fy6cp5wz55w0gd8wakyqvzapjx-stdenv-bootstrap-tools-powerpc64le-unknown-linux-gnu
#
{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/powerpc64le/ac43c444780a80e789fd14fe2114acd4a3b5cf9d/busybox";
    sha256 = "sha256-jtPEAsht4AUAG4MLK8xocQSfveUR4ppU1lS4bGI1VN4=";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/powerpc64le/ac43c444780a80e789fd14fe2114acd4a3b5cf9d/bootstrap-tools.tar.xz";
    sha256 = "sha256-MpIDnpZUK3M17qlnuoxfnK0EgxRosm3TMW1WfPZ1+jU=";
  };
}
