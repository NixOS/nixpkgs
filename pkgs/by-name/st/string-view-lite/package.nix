{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "string-view-lite";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "string-view-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hXm3MLskeZzTegSj79dQV+VcwBatT1VIAUydjisd19U=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  doCheck = true;
  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "C++17-like string_view for C++98, C++11 and later in a single-file header-only library";
    homepage = "https://github.com/martinmoene/string-view-lite";
    changelog = "https://github.com/martinmoene/string-view-lite/blob/v${finalAttrs.version}/CHANGES.txt";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ titaniumtown ];
  };
})
