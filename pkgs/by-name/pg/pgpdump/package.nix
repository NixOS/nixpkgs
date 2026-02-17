{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  supportCompressedPackets ? true,
  zlib,
  bzip2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgpdump";
  version = "0.36";

  src = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "pgpdump";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JKedgHCTDnvLyLR3nGl4XFAaxXDU1TgHrxPMlRFwtBo=";
  };

  patches = [
    # Fix for GCC 15. Remove on next package update.
    # https://github.com/kazu-yamamoto/pgpdump/pull/45
    (fetchpatch2 {
      name = "fix-c23-compatibility.patch";
      url = "https://github.com/kazu-yamamoto/pgpdump/commit/541442dc04259bde680b46742522177be40cc065.patch?full_index=1";
      hash = "sha256-ye+B8hy0etGcwCG9pD0jCnrg+U5VpFkERad61CexW9Y=";
    })
  ];

  buildInputs = lib.optionals supportCompressedPackets [
    zlib
    bzip2
  ];

  meta = {
    description = "PGP packet visualizer";
    mainProgram = "pgpdump";
    longDescription = ''
      pgpdump is a PGP packet visualizer which displays the packet format of
      OpenPGP (RFC 4880) and PGP version 2 (RFC 1991).
    '';
    homepage = "http://www.mew.org/~kazu/proj/pgpdump/en/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
