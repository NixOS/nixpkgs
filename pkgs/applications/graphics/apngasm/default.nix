{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, boost, libpng, zlib }:

stdenv.mkDerivation rec {
  pname = "apngasm";
  version = "3.1.10";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "f105b2d6024ef3113bb407d68e27e476a17fa998";
    sha256 = "sha256-lTk2sTllKHRUaWPPEkC4qU5K10oRaLrdWBgN4MUGKeo=";
  };

  patches = [
    # Fix parallel build and avoid static linking of binary.
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/apngasm/files/apngasm-3.1.10-static.patch?id=45fd0cde71ca2ae0e7e38ab67400d84b86b593d7";
      sha256 = "sha256-eKthgInWxXEqN5PupvVf9wVQDElxsPYRFXT7pMc6vIU=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost libpng zlib ];

  meta = with lib; {
    description = "Create an APNG from multiple PNG files";
    homepage = "https://github.com/apngasm/apngasm";
    license = licenses.zlib;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };

}
