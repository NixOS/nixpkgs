{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  opencv4,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lucidgrasp";
  version = "1.3.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dialga-cmd";
    repo = "LucidGrasp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UPI7YHI3mGoMwfG8QGMLtrNTddtqnAN8BNo8EAWCSy4=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    opencv4
  ];

  meta = {
    description = "High performance image search engine with pixel-level similarity matching";
    homepage = "https://github.com/dialga-cmd/LucidGrasp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dialga-cmd ];
    mainProgram = "LucidGrasp";
    platforms = lib.platforms.linux;
  };
})
