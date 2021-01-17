{lib, stdenv, boost, cmake, pkgconfig, nix, ... }:
stdenv.mkDerivation rec {
  name = "nixos-option";
  src = ./.;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost nix ];
  meta = with lib; {
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ chkno ];
  };
}
