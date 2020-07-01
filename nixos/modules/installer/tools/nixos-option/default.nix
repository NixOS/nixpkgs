{lib, stdenv, boost, cmake, pkgconfig, nix, ... }:
stdenv.mkDerivation rec {
  name = "nixos-option";
  src = ./.;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost nix ];
  meta = {
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ chkno ];
  };
}
