{
  lib,
  stdenv,
  fetchurl,
  cmake,
  openal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alure";
  version = "1.2";

  src = fetchurl {
    url = "http://deb.debian.org/debian/pool/main/a/alure/alure_${finalAttrs.version}.orig.tar.bz2";
    hash = "sha256-Rl5q2uaJJ746AjkDdkZi1kQE5AxMFS0WDjqIOLHXD3E=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openal ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.4)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Utility library to help manage common tasks with OpenAL applications";
    homepage = "https://github.com/kcat/alure";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
