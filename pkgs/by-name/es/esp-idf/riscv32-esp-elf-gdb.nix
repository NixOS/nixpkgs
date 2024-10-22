{
  autoPatchelfHook,
  fetchurl,
  lib,
  python3,
  sourceInfo ?
    (builtins.fromJSON (builtins.readFile ./source-info.json))
    .tools.${stdenvNoCC.system}.riscv32-esp-elf-gdb,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit (sourceInfo) pname version;
  src = fetchurl { inherit (sourceInfo) name url sha256; };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp -R include package.json share $out
    # avoid riscv32-esp-elf-gdb-3.X for other python versions
    cp \
      bin/riscv32-esp-elf-gdb \
      bin/riscv32-esp-elf-gdb-3.${python3.sourceVersion.minor} \
      bin/riscv32-esp-elf-gdb-add-index \
      bin/riscv32-esp-elf-gdb-no-python \
      bin/riscv32-esp-elf-gprof \
      $out/bin
  '';

  nativeBuildInputs = lib.optional stdenvNoCC.isLinux autoPatchelfHook;
  buildInputs = [ python3 ];
}
