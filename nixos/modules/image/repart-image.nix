# This is an expression meant to be called from `./repart.nix`, it is NOT a
# NixOS module that can be imported.

{ lib
, stdenvNoCC
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
, name
, version
, imageFileBasename
, compression
, fileSystems
, partitionsJSON
, split
, seed
, definitionsDirectory
, sectorSize
, mkfsEnv ? {}
, createEmpty ? true
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
  stdenvNoCC.mkDerivation (finalAttrs:
  (if (version != null)
  then { pname = name; inherit version; }
  else { inherit name;  }
  ) // {
  __structuredAttrs = true;

  nativeBuildInputs = [
    systemd
    fakeroot
    util-linux
  ] ++ lib.optionals (compression.enable) [
    compressionPkg
  ] ++ fileSystemTools;

  env = mkfsEnv;

  inherit partitionsJSON definitionsDirectory;

  # relative path to the repart definitions that are read by systemd-repart
  finalRepartDefinitions = "repart.d";

  systemdRepartFlags = [
    "--dry-run=no"
    "--size=auto"
    "--seed=${seed}"
    "--definitions=${finalAttrs.finalRepartDefinitions}"
    "--split=${lib.boolToString split}"
    "--json=pretty"
  ] ++ lib.optionals createEmpty [
    "--empty=create"
  ] ++ lib.optionals (sectorSize != null) [
    "--sector-size=${toString sectorSize}"
  ];

  dontUnpack = true;
  dontConfigure = true;
  doCheck = false;

  patchPhase = ''
    runHook prePatch

    amendedRepartDefinitionsDir=$(${amendRepartDefinitions} $partitionsJSON $definitionsDirectory)
    ln -vs $amendedRepartDefinitionsDir $finalRepartDefinitions

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    echo "Building image with systemd-repart..."
    unshare --map-root-user fakeroot systemd-repart \
      ''${systemdRepartFlags[@]} \
      ${imageFileBasename}.raw \
      | tee repart-output.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
  ''
  # Compression is implemented in the same derivation as opposed to in a
  # separate derivation to allow users to save disk space. Disk images are
  # already very space intensive so we want to allow users to mitigate this.
  + lib.optionalString compression.enable
  ''
    for f in ${imageFileBasename}*; do
      echo "Compressing $f with ${compression.algorithm}..."
      # Keep the original file when compressing and only delete it afterwards
      ${compressionCommand} $f && rm $f
    done
  '' + ''
    mv -v repart-output.json ${imageFileBasename}* $out

    runHook postInstall
  '';

  passthru = {
    inherit amendRepartDefinitions;
  };
})
