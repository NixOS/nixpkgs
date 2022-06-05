{ stdenv, callPackage, fetchurl, lib }:

let
  mkRambox = opts: callPackage (import ./rambox.nix opts) { };
in mkRambox rec {
  pname = "rambox-pro";
  version = "1.5.0";

  desktopName = "Rambox Pro";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/ramboxapp/download/releases/download/v${version}/RamboxPro-${version}-linux-x64.AppImage";
      sha256 = "1g7lrjm8yxklqpc2mp8gy0g61wfilr15dl80r3sh6pa5b4k5spir";
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
