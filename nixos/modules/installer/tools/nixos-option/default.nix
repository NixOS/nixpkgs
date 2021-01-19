{lib, stdenv, boost, cmake, pkg-config, nix, ... }:
stdenv.mkDerivation rec {
  name = "nixos-option";
  src = ./.;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost nix ];
  meta = {
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ chkno ];
  };
}
