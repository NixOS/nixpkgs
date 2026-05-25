{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "expected-lite";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "expected-lite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nxwdymBNbd+RuL8rKi2Fx2gC68TnJe7WnoN0O01lecQ=";
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
    changelog = "https://github.com/martinmoene/expected-lite/blob/${finalAttrs.src.rev}/CHANGES.txt";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ azahi ];
  };
})
