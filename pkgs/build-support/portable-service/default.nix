{
  pkgs,
  lib,
  stdenv,
}:
/*
  Create a systemd portable service image
  https://systemd.io/PORTABLE_SERVICES/

  Example:
  pkgs.portableService {
    pname = "demo";
    version = "1.0";
    units = [ demo-service demo-socket ];
  }
*/
{
  # The name and version of the portable service. The resulting image will be
  # created in result/$pname_$version.raw
  pname,
  version,

  # Units is a list of derivations for systemd unit files. Those files will be
  # copied to /etc/systemd/system in the resulting image. Note that the unit
  # names must be prefixed with the name of the portable service.
  units,

  # Basic info about the portable service image, used for the generated
  # /etc/os-release
  description ? null,
  homepage ? null,

  # A list of attribute sets {object, symlink}. Symlinks will be created
  # in the root filesystem of the image to objects in the nix store.
  symlinks ? [ ],

  # A list of additional derivations to be included in the image as-is.
  contents ? [ ],

  # mksquashfs options
  squashfsTools ? pkgs.squashfsTools,
  squash-compression ? "xz -Xdict-size 100%",
  squash-block-size ? "1M",
}:

let
  filterNull = lib.filterAttrs (_: v: v != null);
  envFileGenerator = lib.generators.toKeyValue { };

  rootFsScaffold =
    let
      os-release-params = {
        PORTABLE_ID = pname;
        PORTABLE_PRETTY_NAME = description;
        HOME_URL = homepage;
        ID = "nixos";
        PRETTY_NAME = "NixOS";
        BUILD_ID = "rolling";
      };
      os-release = pkgs.writeText "os-release" (envFileGenerator (filterNull os-release-params));

    in
    stdenv.mkDerivation {
      pname = "root-fs-scaffold";
      inherit version;

      buildCommand =
        ''
          # scaffold a file system layout
          mkdir -p $out/etc/systemd/system $out/proc $out/sys $out/dev $out/run \
                   $out/tmp $out/var/tmp $out/var/lib $out/var/cache $out/var/log

          # empty files to mount over with host's version
          touch $out/etc/resolv.conf $out/etc/machine-id

          # required for portable services
          cp ${os-release} $out/etc/os-release
        ''
        # units **must** be copied to /etc/systemd/system/
        + (lib.concatMapStringsSep "\n" (u: "cp ${u} $out/etc/systemd/system/${u.name};") units)
        + (lib.concatMapStringsSep "\n" (
          { object, symlink }:
          ''
            mkdir -p $(dirname $out/${symlink});
            ln -s ${object} $out/${symlink};
          ''
        ) symlinks);
    };
in

assert lib.assertMsg (lib.all (
  u: lib.hasPrefix pname u.name
) units) "Unit names must be prefixed with the service name";

stdenv.mkDerivation {
  pname = "${pname}-img";
  inherit version;

  nativeBuildInputs = [ squashfsTools ];
  closureInfo = pkgs.closureInfo { rootPaths = [ rootFsScaffold ] ++ contents; };

  buildCommand = ''
    mkdir -p nix/store
    for i in $(< $closureInfo/store-paths); do
      cp -a "$i" "''${i:1}"
    done

    mkdir -p $out
    # the '.raw' suffix is mandatory by the portable service spec
    mksquashfs nix ${rootFsScaffold}/* $out/"${pname}_${version}.raw" \
      -quiet -noappend \
      -exit-on-error \
      -keep-as-directory \
      -all-root -root-mode 755 \
      -b ${squash-block-size} -comp ${squash-compression}
  '';
}
