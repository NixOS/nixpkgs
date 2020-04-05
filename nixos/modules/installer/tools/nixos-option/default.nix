{lib, stdenv, boost, cmake, pkgconfig, nix, boehmgc, ... }:
stdenv.mkDerivation rec {
  name = "nixos-option";
  src = ./.;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost nix boehmgc ];
  meta = {
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ chkno ];
  };
}
