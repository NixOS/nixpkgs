{
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "qualisys-cpp-sdk";
  version = "2024.2";

  src = fetchFromGitHub {
    owner = "qualisys";
    repo = "qualisys_cpp_sdk";
    rev = "refs/tags/rt_protocol_1.25";
    hash = "sha256-BeG6LF1a8m9BSoILsD9EppywXlCSheKGm0fBoLR1cak=";
  };

  patches = [
    # Fix include dir in CMake export
    (fetchpatch {
      url = "https://github.com/qualisys/qualisys_cpp_sdk/pull/32/commits/db5e22662b7f417b317571a7488b6dcbb82b7538.patch";
      hash = "sha256-q7sNT/kQ9xlRPYKfmhiKg+UaYUsZJ4J2xMyQQNSTgxQ=";
    })
    # don't concatenate CMAKE_INSTALL_PREFIX and absolute CMAKE_INSTALL_INCLUDEDIR
    (fetchpatch {
      url = "https://github.com/nim65s/qualisys_cpp_sdk/commit/1ba8cdb9a8e3583b68d93a553a6f59ea7ee24876.patch";
      hash = "sha256-5CWBvvnlXlh3UkU3S+LVG2rWC8VZ7+EVo+YFKHk6KuY=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++ sdk for talking to Qualisys Track Manager software";
    homepage = "https://github.com/qualisys/qualisys_cpp_sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
}
