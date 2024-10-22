{
  autoPatchelfHook,
  fetchurl,
  lib,
  sourceInfo ?
    (builtins.fromJSON (builtins.readFile ./source-info.json)).tools.${stdenvNoCC.system}.esp32ulp-elf,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit (sourceInfo) pname version;
  src = fetchurl { inherit (sourceInfo) name url sha256; };

  dontBuild = true;
  installPhase = "cp -R . $out";

  nativeBuildInputs = lib.optional stdenvNoCC.isLinux autoPatchelfHook;
}
