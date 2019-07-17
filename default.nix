{ nixpkgs ? import <nixpkgs> {}}:
with nixpkgs;

# rec {
#   common = callPackage ./common.nix {};
#   capt = callPackage ./capt.nix { cndrvcups-common = common;};
#   doc = callPackage ./doc.nix {};
# }

let
  common = callPackage ./common.nix {};
  capt = callPackage ./capt.nix { cndrvcups-common = common;};
  doc = callPackage ./doc.nix {};
in
  stdenv.mkDerivation rec {
    name = "${pname}-${version}";
    pname = "capt-driverpack";
    version = "0.1";

    #TODO: inline systemd service file and set src to null
    src = ./Misc;

    buildInputs = [
      common capt doc
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
      tree ${doc} > $out/doc_build.log

      ##TODO: check how Nix's systemd works and edit `ccpd.service`
      ## Installation of the custom Arch Linux CCPD systemd service
      substituteInPlace ccpd.service \
        --replace ExecStart=/usr/bin/ccpd ExecStart=${capt}/bin/ccpd

      install -dm755 $out/lib/systemd/system/
      install -Dm664 ccpd.service $out/lib/systemd/system/ccpd.service

      ###################################################################
      ##FIXME: the problematic code collected here to be able to cache `capt.nix` build
      ##       move the corresponding line back to where is should belong

      ##FIXME: stuck with invalid group `lp`
      # install -dm750 -o root -g lp $out/var/captmon/

      ##FIXME: how to install a ppd to cups?, need to?
      ##       capt's ppd files are in ${capt}/share/cups/model
      # install -dm755 $out/share/ppd/cupsfilters/
      # for _f in ${capt}/share/cups/model/CN*CAPT*.ppd; do
      #   ln -s $_f $out/share/ppd/cupsfilters
      # done
    '';
  }
