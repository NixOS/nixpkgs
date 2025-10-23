{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "screentest";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "TobiX";
    repo = "screentest";
    tag = finalAttrs.version;
    hash = "sha256-dbag1EAD+6+srfu/eqSl3CWlZtSopioQjyBQRJcUggA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  meta = {
    description = "Simple screen testing tool";
    mainProgram = "screentest";
    homepage = "https://github.com/TobiX/screentest";
    changelog = "https://github.com/TobiX/screentest/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
