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

  # filesystem tools
, dosfstools
, mtools
, e2fsprogs
, squashfsTools
, erofs-utils
, btrfs-progs
, xfsprogs

  # compression tools
, zstd
, xz

  # arguments
, imageFileBasename
, compression
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

  compressionPkg = {
    "zstd" = zstd;
    "xz" = xz;
  }."${compression.algorithm}";

  compressionCommand = {
    "zstd" = "zstd --no-progress --threads=0 -${toString compression.level}";
    "xz" = "xz --keep --verbose --threads=0 -${toString compression.level}";
  }."${compression.algorithm}";
in

runCommand imageFileBasename
{
  nativeBuildInputs = [
    systemd
    fakeroot
    util-linux
    compressionPkg
  ] ++ fileSystemTools;
} ''
  amendedRepartDefinitions=$(${amendRepartDefinitions} ${partitions} ${definitionsDirectory})

  mkdir -p $out
  cd $out

  echo "Building image with systemd-repart..."
  unshare --map-root-user fakeroot systemd-repart \
    --dry-run=no \
    --empty=create \
    --size=auto \
    --seed="${seed}" \
    --definitions="$amendedRepartDefinitions" \
    --split="${lib.boolToString split}" \
    --json=pretty \
    ${imageFileBasename}.raw \
    | tee repart-output.json

  # Compression is implemented in the same derivation as opposed to in a
  # separate derivation to allow users to save disk space. Disk images are
  # already very space intensive so we want to allow users to mitigate this.
  if ${lib.boolToString compression.enable}; then
    for f in ${imageFileBasename}*; do
      echo "Compressing $f with ${compression.algorithm}..."
      # Keep the original file when compressing and only delete it afterwards
      ${compressionCommand} $f && rm $f
    done
  fi
''
