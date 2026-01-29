{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elfio";
  version = "3.10";

  src = fetchFromGitHub {
    owner = "serge1";
    repo = "elfio";
    rev = "Release_${finalAttrs.version}";
    sha256 = "sha256-DuZhkiHXdCplRiOy1Gsu7voVPdCbFt+4qFqlOeOeWQw=";
  };

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [ boost ];

  cmakeFlags = [ "-DELFIO_BUILD_TESTS=ON" ];

  doCheck = true;

  meta = {
    description = "Header-only C++ library for reading and generating files in the ELF binary format";
    homepage = "https://github.com/serge1/ELFIO";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
