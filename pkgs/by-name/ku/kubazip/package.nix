{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kubazip";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "kuba--";
    repo = "zip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wNkIYuwwXo7v3vNaOnRZt1tcd0RGjDvCUqDGdvJzVdo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  doCheck = true;

  meta = {
    description = "Portable, simple zip library written in C";
    homepage = "https://github.com/kuba--/zip";
    changelog = "https://github.com/kuba--/zip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcin-serwin ];
  };
})
