{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cutee,
}:

stdenv.mkDerivation rec {
  pname = "mimetic";
  version = "0.9.8";

  src = fetchurl {
    url = "http://www.codesink.org/download/${pname}-${version}.tar.gz";
    sha256 = "003715lvj4nx23arn1s9ss6hgc2yblkwfy5h94li6pjz2a6xc1rs";
  };

  buildInputs = [ cutee ];

  patches = [
    # Fix build with gcc11
    (fetchpatch {
      url = "https://github.com/tat/mimetic/commit/bf84940f9021950c80846e6b1a5f8b0b55991b00.patch";
      sha256 = "sha256-1JW9zPg67BgNsdIjK/jp9j7QMg50eRMz5FsDsbbzBlI=";
    })
  ]
  ++ lib.optional stdenv.hostPlatform.isAarch64 ./narrowing.patch;

  meta = with lib; {
    description = "MIME handling library";
    homepage = "https://www.codesink.org/mimetic_mime_library.html";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
