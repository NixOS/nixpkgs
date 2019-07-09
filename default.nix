{ nixpkgs ? import <nixpkgs> {}}:
with nixpkgs;

let
  common = callPackage ./common.nix {};
  capt = callPackage ./capt.nix { cndrvcups-common = common;};
in
  # capt

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "capt-driverpack";
  version = "0.1";

  src = ./.;

  buildInputs = [
    common capt
    tree
  ];

  # install directions based on arch PKGBUILD file
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=capt-src

  installPhase = ''
    set -ex

    mkdir -p $out

    ##NOTE: list output of `common` and `capt` for debugging
    tree ${common} > $out/common_build.log
    tree ${capt} > $out/capt_build.log

    ##NOTE: include other external files outside the source section below,

    # Custom License
    install -dm755 $out/share/licenses
    install -Dm664 Doc/LICENSE-EN.txt $out/share/licenses/LICENSE-EN.txt

    # Guide & README
    install -Dm664 Doc/guide-capt-2.7xUK.tar.gz $out/share/doc/capt-src/guide-capt-2.7xUK.tar.gz
    install -Dm664 Doc/README-capt-2.71UK.txt $out/share/doc/capt-src/README-capt-2.71UK.txt
    install -dm755 $out/share/ppd/cupsfilters

    ###################################################################
    ##FIXME: the problematic code collected here to be able to cache `capt.nix` build
    ##       move the corresponding line back to where is should belong

    ##FIXME: stuck with invalid group `lp`
    # install -dm750 -o root -g lp $out/var/captmon/

    ##TODO: check how Nix's systemd works and edit `ccpd.service`

    # Installation of the custom Arch Linux CCPD systemd service
    install -dm755 $out/lib/systemd/system/
    install -Dm664 ccpd.service $out/lib/systemd/system/ccpd.service

    ##FIXME: how to install a ppd to cups?
    # pushd $out/share/cups/model
    #   for fn in CN*CAPT*.ppd; do
    #       ln -s /share/cups/model/$fn $out/share/ppd/cupsfilters/$fn
    #   done
    # popd

  '';
}

