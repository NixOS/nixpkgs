{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dlpack";
  version = "1.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dmlc";
    repo = "dlpack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kIHBgTYaHEmweRBFtRl1pXhOyQ5TEwU8dLUssTMEnpc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  # no tests
  doCheck = false;

  meta = {
    description = "Open in-memory tensor structure for sharing tensors among frameworks";
    homepage = "https://github.com/dmlc/dlpack";
    downloadPage = "https://github.com/dmlc/dlpack/releases";
    changelog = "https://github.com/dmlc/dlpack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
