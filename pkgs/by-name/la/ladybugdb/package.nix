{
  lib,
  stdenv,
  cmake,
  ninja,
  python3,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ladybugdb";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "LadybugDB";
    repo = "ladybug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hc0SltZYreENpa3PyCSgj72tSVVIiIJRQSN0f33iPr8=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/lbug";
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/LadybugDB/ladybug/releases/tag/${finalAttrs.src.tag}";
    description = "Embeddable property graph database management system (fork of Kuzu)";
    homepage = "https://ladybugdb.com/";
    license = lib.licenses.mit;
    mainProgram = "lbug";
    maintainers = with lib.maintainers; [ hamidr ];
    platforms = lib.platforms.all;
  };
})
