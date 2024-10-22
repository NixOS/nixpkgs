{
  autoPatchelfHook,
  darwin,
  fetchurl,
  lib,
  sourceInfo ?
    (builtins.fromJSON (builtins.readFile ./source-info.json)).tools.${stdenv.system}.xtensa-esp-elf,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (sourceInfo) pname version;
  src = fetchurl { inherit (sourceInfo) name url sha256; };

  dontBuild = true;
  installPhase = "cp -R . $out";

  preFixup = lib.optionalString stdenv.isDarwin ''
    for lib in $out/lib/*.so
    do install_name_tool -id $lib $lib
    done
  '';

  nativeBuildInputs =
    lib.optional stdenv.isLinux autoPatchelfHook
    ++ lib.optional stdenv.isDarwin darwin.autoSignDarwinBinariesHook;
  buildInputs = [ stdenv.cc.cc.lib ];
}
