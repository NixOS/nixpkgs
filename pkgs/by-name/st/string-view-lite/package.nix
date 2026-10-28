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
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "nonstd-lite";
    repo = "string-view-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L22wItXKg+W2bchdHwGLagRlBCkUNKGs31dUwvAZUro=";
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
    homepage = "https://github.com/nonstd-lite/string-view-lite";
    changelog = "https://github.com/nonstd-lite/string-view-lite/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ titaniumtown ];
  };
})
