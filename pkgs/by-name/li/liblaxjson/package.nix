{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.0.5";
  pname = "liblaxjson";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "liblaxjson";
    rev = finalAttrs.version;
    sha256 = "01iqbpbhnqfifhv82m6hi8190w5sdim4qyrkss7z1zyv3gpchc5s";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Library for parsing JSON config files";
    homepage = "https://github.com/andrewrk/liblaxjson";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [ lib.maintainers.andrewrk ];
  };
})
