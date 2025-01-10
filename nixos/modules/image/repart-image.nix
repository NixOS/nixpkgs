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
  systemdArch = let
    inherit (stdenvNoCC) hostPlatform;
  in
    if hostPlatform.isAarch32 then "arm"
    else if hostPlatform.isAarch64 then "arm64"
    else if hostPlatform.isx86_32 then "x86"
    else if hostPlatform.isx86_64 then "x86-64"
    else if hostPlatform.isMips32 then "mips-le"
    else if hostPlatform.isMips64 then "mips64-le"
    else if hostPlatform.isPower then "ppc"
    else if hostPlatform.isPower64 then "ppc64"
    else if hostPlatform.isRiscV32 then "riscv32"
    else if hostPlatform.isRiscV64 then "riscv64"
    else if hostPlatform.isS390 then "s390"
    else if hostPlatform.isS390x then "s390x"
    else if hostPlatform.isLoongArch64 then "loongarch64"
    else if hostPlatform.isAlpha then "alpha"
    else hostPlatform.parsed.cpu.name;

  amendRepartDefinitions = runCommand "amend-repart-definitions.py"
    {
      # TODO: ruff does not splice properly in nativeBuildInputs
      depsBuildBuild = [ ruff ];
      nativeBuildInputs = [ python3 black mypy ];
    } ''
    install ${./amend-repart-definitions.py} $out
    patchShebangs --build $out

    black --check --diff $out
    ruff check --line-length 88 $out
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
    "zstd" = "zstd --no-progress --threads=$NIX_BUILD_CORES -${toString compression.level}";
    "xz" = "xz --keep --verbose --threads=$NIX_BUILD_CORES -${toString compression.level}";
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
  ] ++ lib.optionals (compression.enable) [
    compressionPkg
  ] ++ fileSystemTools;

  env = mkfsEnv;

  inherit partitionsJSON definitionsDirectory;

  # relative path to the repart definitions that are read by systemd-repart
  finalRepartDefinitions = "repart.d";

  systemdRepartFlags = [
    "--architecture=${systemdArch}"
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
    fakeroot systemd-repart \
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
