{ stdenv, callPackage, fetchurl, lib }:

let
  mkRambox = opts: callPackage (import ./rambox.nix opts) { };
in mkRambox rec {
  pname = "rambox-pro";
  version = "2.0.9";

  desktopName = "Rambox Pro";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/ramboxapp/download/releases/download/v${version}/Rambox-${version}-linux-x64.AppImage";
      hash = "sha256-o2ydZodmMAYeU0IiczKNlzY2hgTJbzyJWO/cZSTfAuM=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = with lib; {
    description = "Messaging and emailing app that combines common web applications into one";
    homepage = "https://rambox.pro";
    license = licenses.unfree;
    maintainers = with maintainers; [ cawilliamson ];
    platforms = [ "x86_64-linux" ];
  };
}
