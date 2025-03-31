{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "duckx";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "amiremohamadi";
    repo = "DuckX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qRqYcBi/a2tUSlLAa7DKPqwQsctw5/0hjV/Og1pHPQU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    # https://github.com/amiremohamadi/DuckX/issues/92
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "14")
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "C++ library for creating and modifying Microsoft Word (.docx) files";
    homepage = "https://github.com/amiremohamadi/DuckX";
    changelog = "https://github.com/amiremohamadi/DuckX/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ titaniumtown ];
  };
})
