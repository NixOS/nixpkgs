{
  runCommand, squashfsTools, closureInfo, lib, jq, writeText
}:

{
  # The meta parameter is the contents of the `snap.yaml`, NOT the
  # `snapcraft.yaml`.
  #
  # - `snap.yaml` is what is inside of the final Snap,
  # - `snapcraft.yaml` is used by `snapcraft` to build snaps
  #
  # Since we skip the `snapcraft` tool, we skip the `snapcraft.yaml`
  # file. For more information:
  #
  #   https://docs.snapcraft.io/snap-format
  #
  # Note: unsquashfs'ing an existing snap from the store can be helpful
  # for determining what you you're missing.
  #
  meta
}: let
    snap_yaml = let
      # Validate the snap's meta contains a name.
      # Also: automatically set the `base` parameter and the layout for
      # the `/nix` bind.
      validate = { name, ... } @ args:
        args // {
          # Combine the provided arguments with the required options.

          # base: built from https://github.com/NixOS/snapd-nix-base
          # and published as The NixOS Foundation on the Snapcraft store.
          base = "nix-base";
          layout = (args.layout or {}) // {
            # Bind mount the Snap's root nix directory to `/nix` in the
            # execution environment's filesystem namespace.
            "/nix".bind = "$SNAP/nix";
          };
        };
    in writeText "snap.yaml"
      (builtins.toJSON (validate meta));

  # These are specifically required by snapd, so don't change them
  # unless you've verified snapcraft / snapd can handle them. Best bet
  # is to just mirror this list against how snapcraft creates images.
  # from: https://github.com/snapcore/snapcraft/blob/b88e378148134383ffecf3658e3a940b67c9bcc9/snapcraft/internal/lifecycle/_packer.py#L96-L98
  mksquashfs_args = [
    "-noappend" "-comp" "xz" "-no-xattrs" "-no-fragments"

    # Note: We want -all-root every time, since all the files are
    # owned by root anyway. This is true for Nix, but not true for
    # other builds.
    # from: https://github.com/snapcore/snapcraft/blob/b88e378148134383ffecf3658e3a940b67c9bcc9/snapcraft/internal/lifecycle/_packer.py#L100
    "-all-root"
  ];

in runCommand "squashfs.img" {
  nativeBuildInputs = [ squashfsTools jq ];

  closureInfo = closureInfo {
    rootPaths = [ snap_yaml ];
  };
} ''
  root=$PWD/root
  mkdir $root

  (
    # Put the snap.yaml in to `/meta/snap.yaml`, setting the version
    # to the hash part of the store path
    mkdir $root/meta
    version=$(echo $out | cut -d/ -f4 | cut -d- -f1)
    cat ${snap_yaml} | jq  ". + { version: \"$version\" }" \
      > $root/meta/snap.yaml
  )

  (
    # Copy the store closure in to the root
    mkdir -p $root/nix/store
    cat $closureInfo/store-paths | xargs -I{} cp -r {} $root/nix/store/
  )

  # Generate the squashfs image.
  mksquashfs $root $out \
    ${lib.concatStringsSep " " mksquashfs_args}
''
