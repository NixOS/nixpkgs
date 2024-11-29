{
  boost,
  cmake,
  doxygen,
  eigen,
  fetchFromGitHub,
  jrl-cmakemodules,
  lib,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eiquadprog";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "eiquadprog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VqRx06sCCZrnB+NWm6Z9OMKzjKQIydGgKQU6fMY7phk=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    jrl-cmakemodules
  ];
  propagatedBuildInputs = [ eigen ];
  checkInputs = [ boost ];

  doCheck = true;

  meta = {
    description = "C++ reimplementation of eiquadprog";
    homepage = "https://github.com/stack-of-tasks/eiquadprog";
    changelog = "https://github.com/stack-of-tasks/eiquadprog/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
