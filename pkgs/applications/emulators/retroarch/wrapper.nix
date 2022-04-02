{ stdenv, lib, makeWrapper, retroarch, cores ? [ ] }:

stdenv.mkDerivation {
  pname = "retroarch";
  version = lib.getVersion retroarch;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/lib
    for coreDir in $cores
    do
      ln -s $coreDir/* $out/lib/.
    done

    ln -s -t $out ${retroarch}/share

    if [ -d ${retroarch}/Applications ]; then
      ln -s -t $out ${retroarch}/Applications
    fi

    makeWrapper ${retroarch}/bin/retroarch $out/bin/retroarch \
      --suffix-each LD_LIBRARY_PATH ':' "$cores" \
      --add-flags "-L $out/lib/" \
  '';

  cores = map (x: x + x.libretroCore) cores;
  preferLocalBuild = true;

  meta = with retroarch.meta; {
    inherit changelog description homepage license maintainers platforms;
    longDescription =
      "RetroArch is the reference frontend for the libretro API. The following cores are included: "
      + lib.concatStringsSep ", " (map (x: "${x.name}") cores)
      + ".";
  };
}
