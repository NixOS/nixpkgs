{
  autoPatchelfHook,
  fetchurl,
  lib,
  libusb1,
  libz,
  sourceInfo ?
    (builtins.fromJSON (builtins.readFile ./source-info.json)).tools.${stdenvNoCC.system}.openocd-esp32,
  stdenvNoCC,
  systemd,
}:
stdenvNoCC.mkDerivation {
  inherit (sourceInfo) pname version;
  src = fetchurl { inherit (sourceInfo) name url sha256; };

  dontBuild = true;
  installPhase = "cp -R . $out";

  nativeBuildInputs = lib.optional stdenvNoCC.isLinux autoPatchelfHook;
  buildInputs = lib.optional stdenvNoCC.isLinux systemd ++ [
    libusb1
    libz
  ];
}
