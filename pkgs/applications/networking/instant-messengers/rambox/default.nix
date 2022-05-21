{ stdenv, callPackage, fetchurl, lib }:

let
  mkRambox = opts: callPackage (import ./rambox.nix opts) {};
in
mkRambox rec {
  pname = "rambox";
  version = "2.0.5";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/ramboxapp/download/releases/download/v${version}/Rambox-${version}-linux-x64.AppImage";
      sha256 = "19y4cmrfp79dr4hgl698imp4f3l1nhgvhh76j5laxg46ld71knil";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = with lib; {
    description = "Free and Open Source messaging and emailing app that combines common web applications into one";
    homepage = "https://rambox.pro";
    license = licenses.mit;
    maintainers = with maintainers; [];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [];
  };
}
