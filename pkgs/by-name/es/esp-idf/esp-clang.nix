{
  autoPatchelfHook,
  fetchurl,
  lib,
  libxml2,
  libz,
  sourceInfo ?
    (builtins.fromJSON (builtins.readFile ./source-info.json)).tools.${stdenv.system}.esp-clang,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (sourceInfo) pname version;
  src = fetchurl { inherit (sourceInfo) name url sha256; };

  dontBuild = true;
  installPhase = "cp -R . $out";

  nativeBuildInputs = lib.optional stdenv.isLinux autoPatchelfHook;
  buildInputs = [
    libxml2
    libz
    stdenv.cc.cc.lib
  ];
}
