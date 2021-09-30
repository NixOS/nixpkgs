{ stdenv, callPackage, fetchurl, lib }:

let
  mkRambox = opts: callPackage (import ./rambox.nix opts) {};
in
mkRambox rec {
  pname = "rambox";
  version = "0.7.9";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/ramboxapp/community-edition/releases/download/${version}/Rambox-${version}-linux-x86_64.AppImage";
      sha256 = "19y4cmrfp79dr4hgl698imp4f3l1nhgvhh76j5laxg46ld71knil";
    };
    i686-linux = fetchurl {
      url = "https://github.com/ramboxapp/community-edition/releases/download/${version}/Rambox-${version}-linux-i386.AppImage";
      sha256 = "13wiciyshyrabq2mvnssl2d6svia1kdvwx3dl26249iyif96xxvq";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = with lib; {
    description = "Free and Open Source messaging and emailing app that combines common web applications into one";
    homepage = "https://rambox.pro";
    license = licenses.mit;
    maintainers = with maintainers; [];
    platforms = [ "i686-linux" "x86_64-linux" ];
    hydraPlatforms = [];
  };
}
