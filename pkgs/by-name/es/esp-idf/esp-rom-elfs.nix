{
  fetchurl,
  sourceInfo ? (builtins.fromJSON (builtins.readFile ./source-info.json)).tools.any.esp-rom-elfs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit (sourceInfo) pname version;
  src = fetchurl { inherit (sourceInfo) name url sha256; };

  # work around "unpacker appears to have produced no directories"
  sourceRoot = ".";

  dontBuild = true;
  installPhase = "cp -R . $out";
}
