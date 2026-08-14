{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kubazip";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "kuba--";
    repo = "zip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-phOhhNc59ALKNCCetD3lyRp6ipAlSEMpWTnKPkha3EY=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v([0-9]+\\.[0-9]+\\.[0-9]+)"
    ];
  };

  meta = {
    description = "Portable, simple zip library written in C";
    homepage = "https://github.com/kuba--/zip";
    changelog = "https://github.com/kuba--/zip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcin-serwin ];
  };
})
