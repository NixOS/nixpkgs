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
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "LadybugDB";
    repo = "ladybug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wqvX6yPhh1CbviPgcRW4XOmNjLe5s9FaqHYDFs7GQOg=";
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
