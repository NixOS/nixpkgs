{ lib
, stdenv
, makeWrapper
, retroarch
, symlinkJoin
, cores ? [ ]
}:

let
  coresPath = lib.lists.unique (map (c: c.libretroCore) cores);
  wrapperArgs = lib.strings.escapeShellArgs
    (lib.lists.flatten
      (map (corePath: [ "--add-flags" "-L ${placeholder "out" + corePath}" ]) coresPath));
in
symlinkJoin {
  name = "retroarch-with-cores-${lib.getVersion retroarch}";

  paths = [ retroarch ] ++ cores;

  nativeBuildInputs = [ makeWrapper ];

  passthru = {
    inherit cores;
    unwrapped = retroarch;
  };

  postBuild = ''
    # remove core specific binaries
    find $out/bin -name 'retroarch-*' -delete
    # wrapProgram can't operate on symlinks
    rm $out/bin/retroarch
    makeWrapper ${retroarch}/bin/retroarch $out/bin/retroarch \
      ${wrapperArgs}
  '';

  meta = with retroarch.meta; {
    inherit changelog description homepage license maintainers platforms;
    longDescription = ''
      RetroArch is the reference frontend for the libretro API.
    ''
    + lib.optionalString (cores != [ ]) ''
      The following cores are included: ${lib.concatStringsSep ", " (map (x: x.core) cores)}
    '';
    mainProgram = "retroarch";
  };
}
