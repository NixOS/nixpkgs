{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "expected-lite";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "expected-lite";
    rev = "v${version}";
    hash = "sha256-LRXxUaDQT5q9dXK2uYFvCgEuGWEHKr95lfdGTGjke0g=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  doCheck = true;

  meta = {
    description = ''
      Expected objects in C++11 and later in a single-file header-only library
    '';
    homepage = "https://github.com/martinmoene/expected-lite";
    changelog = "https://github.com/martinmoene/expected-lite/blob/${src.rev}/CHANGES.txt";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ azahi ];
  };
}
