{ lib, stdenv, fetchFromGitHub, boost, cmake, libcifpp, zlib, }:

stdenv.mkDerivation rec {
  pname = "dssp";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x35rdcm4fch66pjbmy73lv0gdb6g9y3v023a66512a6nzsqjsir";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost libcifpp zlib ];

  meta = with lib; {
    description = "Calculate the most likely secondary structure assignment given the 3D structure of a protein";
    homepage = "https://github.com/PDB-REDO/dssp";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
