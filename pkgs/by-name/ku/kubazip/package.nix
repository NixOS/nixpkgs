{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kubazip";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "kuba--";
    repo = "zip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iVxUxF1zF5cEUyENRZKMCw6MRd0hrsokY+UD6jwbBTA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "-Werror" ""
  '';

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
