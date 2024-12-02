{ stdenvNoCC, lib, glibc, musl }:

let
   libc =
     if stdenvNoCC.targetPlatform.isMusl
     then musl
     else glibc;
   headerPath =
     if stdenvNoCC.targetPlatform.isMusl
     then "musl-${libc.version}/include/elf.h"
     else "glibc-${libc.version}/elf/elf.h";
in

stdenvNoCC.mkDerivation {
  pname = "elf-header";
  inherit (libc) version;

  src = null;

  dontUnpack = true;

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/include";
    tar -xf \
        ${lib.escapeShellArg libc.src} \
        ${lib.escapeShellArg headerPath} \
        --to-stdout \
      | sed -e '/features\.h/d' \
      > "$out/include/elf.h"
  '';

  meta = libc.meta // {
    outputsToInstall = [ "out" ];
    description = "Datastructures of ELF according to the target platform's libc";
    longDescription = ''
      The Executable and Linkable Format (ELF, formerly named Extensible Linking
      Format), is usually defined in a header like this.
    '';
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ericson2314 ];
  };
}
