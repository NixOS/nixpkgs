{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "flatcc";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    rev = "v${version}";
    sha256 = "sha256-0/IZ7eX6b4PTnlSSdoOH0FsORGK9hrLr1zlr/IHsJFQ=";
  };

  patches = [
    # Fix builds on clang15. Remove post-0.6.1.
    (fetchpatch {
      name = "clang15fixes.patch";
      url = "https://github.com/dvidelabs/flatcc/commit/5885e50f88248bc7ed398880c887ab23db89f05a.patch";
      hash = "sha256-z2HSxNXerDFKtMGu6/vnzGRlqfz476bFMjg4DVfbObQ";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFLATCC_INSTALL=on"
  ];

  meta = with lib; {
    description = "FlatBuffers Compiler and Library in C for C";
    mainProgram = "flatcc";
    homepage = "https://github.com/dvidelabs/flatcc";
    license = [ licenses.asl20 ];
    maintainers = with maintainers; [ onny ];
  };
}
