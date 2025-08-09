{
  lib,
  stdenv,
  pkgs,
}:

let
  pname = "ecdsautils";
  version = "0.4.2";
in
stdenv.mkDerivation {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "freifunk-gluon";
    repo = "ecdsautils";
    rev = "v${version}";
    sha256 = "sha256-vGHLAX/XOtePvdT/rljCOdlILHVO20mCt6p+MUi13dg=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    doxygen
  ];
  buildInputs = with pkgs; [ libuecc ];

  meta = with lib; {
    description = "Tiny collection of programs used for ECDSA (keygen, sign, verify)";
    homepage = "https://github.com/freifunk-gluon/ecdsautils/";
    license = with licenses; [
      mit
      bsd2
    ];
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
