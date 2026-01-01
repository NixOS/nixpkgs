{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "elfio";
  version = "3.10";

  src = fetchFromGitHub {
    owner = "serge1";
    repo = "elfio";
    rev = "Release_${version}";
    sha256 = "sha256-DuZhkiHXdCplRiOy1Gsu7voVPdCbFt+4qFqlOeOeWQw=";
  };

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [ boost ];

  cmakeFlags = [ "-DELFIO_BUILD_TESTS=ON" ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Header-only C++ library for reading and generating files in the ELF binary format";
    homepage = "https://github.com/serge1/ELFIO";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ prusnak ];
=======
  meta = with lib; {
    description = "Header-only C++ library for reading and generating files in the ELF binary format";
    homepage = "https://github.com/serge1/ELFIO";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ prusnak ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
