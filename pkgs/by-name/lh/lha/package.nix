{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "lha";
  version = "unstable-2021-01-07";

  src = fetchFromGitHub {
    owner = "jca02266";
    repo = "lha";
    rev = "03475355bc6311f7f816ea9a88fb34a0029d975b";
    sha256 = "18w2x0g5yq89yxkxh1fmb05lz4hw7a3b4jmkk95gvh11mwbbr5lm";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "LHa is an archiver and compressor using the LZSS and Huffman encoding compression algorithms";
    platforms = platforms.unix;
    maintainers = [ maintainers.sander ];
    # Some of the original LhA code has been rewritten and the current author
    # considers adopting a "true" free and open source license for it.
    # However, old code is still covered by the original LHa license, which is
    # not a free software license (it has additional requirements on commercial
    # use).
    license = licenses.unfree;
    mainProgram = "lha";
  };
}
