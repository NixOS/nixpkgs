{
  lib,
  cmake,
  gtest,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simpleini";
  version = "4.22";

  src = fetchFromGitHub {
    name = "simpleini-sources-${finalAttrs.version}";
    owner = "brofield";
    repo = "simpleini";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-H4J4+v/3A8ZTOp4iMeiZ0OClu68oP4vUZ8YOFZbllcM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "SIMPLEINI_USE_SYSTEM_GTEST" true)
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/brofield/simpleini";
    description = "Cross-platform C++ library providing a simple API to read and write INI-style configuration files";
    longDescription = ''
      A cross-platform library that provides a simple API to read and write
      INI-style configuration files. It supports data files in ASCII, MBCS and
      Unicode. It is designed explicitly to be portable to any platform and has
      been tested on Windows, WinCE and Linux. Released as open-source and free
      using the MIT licence.
    '';
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
