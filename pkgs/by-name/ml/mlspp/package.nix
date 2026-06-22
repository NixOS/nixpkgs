{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nlohmann_json,
  openssl,
}:

stdenv.mkDerivation {
  pname = "mlspp";
  version = "0.1.0-unstable-2026-04-13";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "mlspp";
    rev = "92aaa4134fa45ec39957a7c81a342401fba7feb2";
    hash = "sha256-HElw0fvL7ClDSXBDYRw1qcPw73oWvbMfi7skQokyftY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    nlohmann_json
    openssl
  ];

  cmakeFlags = [
    "-DMLS_CXX_NAMESPACE=mlspp"
    "-DBUILD_TESTS=OFF"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "-Werror" ""
  '';

  meta = {
    description = "Messaging Layer Security (MLS) protocol implementation";
    homepage = "https://github.com/cisco/mlspp";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ choco98 ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
