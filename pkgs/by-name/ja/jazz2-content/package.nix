{
  jazz2,
  lib,
  runCommandLocal,
}:

runCommandLocal "jazz2-content"
  {
    inherit (jazz2) version src;

    meta = (builtins.removeAttrs jazz2.meta [ "mainProgram" ]) // {
      description = "Assets needed for jazz2";
      platforms = lib.platforms.all;
    };
  }
  ''
    cp -r $src/Content $out
  ''
