{
  autoPatchelfHook,
  cups,
  dpkg,
  fetchurl,
  lib,
  stdenv,
}:
let
  pname = "rollo-cups-driver";
  version = "1.8.4";

  src =
    let
      arch =
        if stdenv.system == "x86_64-linux" then
          "amd64"
        else if stdenv.system == "aarch64-linux" then
          "arm64"
        else
          throw "Unsupported system: ${stdenv.system}";
    in
    {
      x86_64-linux = fetchurl {
        url = "https://rollo-main.b-cdn.net/driver-dl/linux/rollo-cups-driver_${version}-1_${arch}.deb";
        hash = "sha256-01SKxC5qPdfpMqsCR6UuogmvbrYwF7BI+C1ptURfNko=";
      };
      aarch64-linux = fetchurl {
        url = "https://rollo-main.b-cdn.net/driver-dl/linux/rollo-cups-driver_${version}-1_${arch}.deb";
        hash = "sha256-D0+dL+oTZ0RGbh22jN++4NvsK/2dCw3MdYztIoicUIk=";
      };
    }
    .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    description = "CUPS driver for Rollo label printers";
    homepage = "https://www.rollo.com/driver-linux/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; unfree;
    maintainers = with lib.maintainers; [ shymega ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    cups
  ];

  unpackPhase = "dpkg-deb -x $src $out";
}
