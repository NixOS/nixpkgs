{
  lib,
  stdenv,
  fetchFromGitHub,
  cpm-cmake,
  cmake,
  python3,
}:

stdenv.mkDerivation {
  pname = "sk_gpu";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Pandapip1";
    repo = "sk_gpu";
    rev = "973f8730bba240d8f5b9fb130ca17596711fb154";
    hash = "sha256-gM+M/1AgwAHxx4Pz/lwMzADyOI+vKMiKOr8Mbeootd4=";
  };

  cmakeFlags = [
    (lib.cmakeFeature "CPM_DOWNLOAD_LOCATION" "${cpm-cmake}/share/cpm/CPM.cmake")
    (lib.cmakeBool "SK_BUILD_SHADERC" false)
    (lib.cmakeBool "SK_BUILD_EDITOR" false)
    (lib.cmakeBool "SK_BUILD_EXAMPLES" false)
  ];

  nativeBuildInputs = [
    python3
    cmake
  ];
}
