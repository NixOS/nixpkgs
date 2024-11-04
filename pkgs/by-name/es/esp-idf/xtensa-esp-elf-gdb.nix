{
  autoPatchelfHook,
  fetchurl,
  lib,
  python3,
  sourceInfo ?
    (builtins.fromJSON (builtins.readFile ./source-info.json))
    .tools.${stdenvNoCC.system}.xtensa-esp-elf-gdb,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit (sourceInfo) pname version;
  src = fetchurl { inherit (sourceInfo) name url sha256; };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp -R include lib package.json share $out
    # avoid xtensa-esp-elf-gdb-3.X for other python versions
    cp \
      bin/xtensa-esp-elf-gdb-3.${python3.sourceVersion.minor} \
      bin/xtensa-esp-elf-gdb-add-index \
      bin/xtensa-esp-elf-gdb-no-python \
      bin/xtensa-esp-elf-gprof \
      bin/xtensa-esp32-elf-gdb \
      bin/xtensa-esp32s2-elf-gdb \
      bin/xtensa-esp32s3-elf-gdb \
      $out/bin
  '';

  nativeBuildInputs = lib.optional stdenvNoCC.isLinux autoPatchelfHook;
  buildInputs = [ python3 ];
}
