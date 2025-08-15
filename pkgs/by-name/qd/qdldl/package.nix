{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdldl";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "osqp";
    repo = "qdldl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qCeOs4UjZLuqlbiLgp6BMxvw4niduCPDOOqFt05zi2E=";
  };

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
