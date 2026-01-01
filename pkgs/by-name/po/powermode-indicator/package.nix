{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtkmm3,
  glibmm,
  libappindicator,
}:
stdenv.mkDerivation {
  pname = "powermode-indicator";
  version = "0-unstable-2024-07-13";

  src = fetchFromGitHub {
    owner = "PiyushXCoder";
    repo = "powermode-indicator";
    rev = "0a67f63290b087f1eeff2c6c6869c2122ac78e6f";
    hash = "sha256-qqV99s+uNYCUx/xGY3gQL38eG9siuKTRT0bA2UoN6Sk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libappindicator
    gtkmm3
    glibmm
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/PiyushXCoder/powermode-indicator";
    description = "Tray tool for power profiles management";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.aacebedo ];
=======
  meta = with lib; {
    homepage = "https://github.com/PiyushXCoder/powermode-indicator";
    description = "Tray tool for power profiles management";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.aacebedo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "powermode-indicator";
  };
}
