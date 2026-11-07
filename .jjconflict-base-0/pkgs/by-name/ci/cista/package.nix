{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cista";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "felixguendling";
    repo = "cista";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q7IDQckFa/iMZ/f3Bim/yWyKCGqsNxJJ5C9PTToFZYI=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCISTA_INSTALL=ON" ];

  meta = {
    homepage = "https://cista.rocks";
    description = "Simple, high-performance, zero-copy C++ serialization & reflection library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sigmanificient ];
    platforms = lib.platforms.all;
  };
})
