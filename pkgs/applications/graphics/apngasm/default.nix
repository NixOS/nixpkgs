{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  libpng,
  zlib,
}:

stdenv.mkDerivation {
  pname = "apngasm";
  version = "3.1.10";

  src = fetchFromGitHub {
    owner = "apngasm";
    repo = "apngasm";
    rev = "f105b2d6024ef3113bb407d68e27e476a17fa998";
    sha256 = "sha256-lTk2sTllKHRUaWPPEkC4qU5K10oRaLrdWBgN4MUGKeo=";
  };

  patches = [
    # Fix parallel build and avoid static linking of binary.
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/apngasm/files/apngasm-3.1.10-static.patch?id=45fd0cde71ca2ae0e7e38ab67400d84b86b593d7";
      sha256 = "sha256-eKthgInWxXEqN5PupvVf9wVQDElxsPYRFXT7pMc6vIU=";
    })
    # Boost 1.89+ removed the boost_system CMake component
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/apngasm/files/apngasm-3.1.10-boost-1.89.patch?id=87e57d47db8c7c68acb2dec534e70015d8b1d61e";
      sha256 = "sha256-92oie9owUYP8a1hrJsFCRk8QI4AjTzMXTe+frlmbIuE=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libpng
    zlib
  ];

  meta = {
    description = "Create an APNG from multiple PNG files";
    homepage = "https://github.com/apngasm/apngasm";
    license = lib.licenses.zlib;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "apngasm";
  };

}
