{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdldl";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "osqp";
    repo = "qdldl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pRlxqy5G8mxKXTIn4ruV/95TzpzNB/ArJX+WrEJRqW4=";
  };

  # fix abs dir concatenation
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "$<INSTALL_PREFIX>/$""{CMAKE_INSTALL_INCLUDEDIR}" \
      "$""{CMAKE_INSTALL_INCLUDEDIR}"
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Free LDL factorisation routine";
    homepage = "https://github.com/osqp/qdldl";
    changelog = "https://github.com/osqp/qdldl/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "qdldl";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
