# This is an expression meant to be called from `./repart.nix`, it is NOT a
# NixOS module that can be imported.

{ lib
, runCommand
, python3
, black
, ruff
, mypy
, systemd
, fakeroot
, util-linux
, dosfstools
, mtools
, e2fsprogs
, squashfsTools
, erofs-utils
, btrfs-progs
, xfsprogs

  # arguments
, name
, fileSystems
, partitions
, split
, seed
, definitionsDirectory
}:

let
  amendRepartDefinitions = runCommand "amend-repart-definitions.py"
    {
      # TODO: ruff does not splice properly in nativeBuildInputs
      depsBuildBuild = [ ruff ];
      nativeBuildInputs = [ python3 black mypy ];
    } ''
    install ${./amend-repart-definitions.py} $out
    patchShebangs --build $out

    black --check --diff $out
    ruff --line-length 88 $out
    mypy --strict $out
  '';

  fileSystemToolMapping = {
    "vfat" = [ dosfstools mtools ];
    "ext4" = [ e2fsprogs.bin ];
    "squashfs" = [ squashfsTools ];
    "erofs" = [ erofs-utils ];
    "btrfs" = [ btrfs-progs ];
    "xfs" = [ xfsprogs ];
  };

  fileSystemTools = builtins.concatMap (f: fileSystemToolMapping."${f}") fileSystems;
in

runCommand name
{
  nativeBuildInputs = [
    systemd
    fakeroot
    util-linux
  ] ++ fileSystemTools;
} ''
  amendedRepartDefinitions=$(${amendRepartDefinitions} ${partitions} ${definitionsDirectory})

  mkdir -p $out
  cd $out

  unshare --map-root-user fakeroot systemd-repart \
    --dry-run=no \
    --empty=create \
    --size=auto \
    --seed="${seed}" \
    --definitions="$amendedRepartDefinitions" \
    --split="${lib.boolToString split}" \
    --json=pretty \
    image.raw \
    | tee repart-output.json
''
