{
  busybox,
  cmake,
  fakeroot,
  fetchFromGitLab,
  gitUpdater,
  lib,
  python3,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mkroot-utils";
  version = "0.5.3";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "mkroot-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BT0OSK6QzxCegj8cXQcBbdfxoj+GxfGfDkyry0JN4Jo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    python3
  ];

  prePatch = ''
    substituteInPlace CMakeLists.txt flash/flash.c pico/picoget.c --replace-fail '/bin/ash' '${lib.getExe' busybox "ash"}'
    patchShebangs test
  '';

  nativeCheckInputs = [ fakeroot ];

  doCheck = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Simple utilities to extend RunC and \"mkroot\"";
    homepage = "https://gitlab.com/arpa2/mkroot-utils";
    license = lib.licenses.bsd2;
    teams = with lib.teams; [ ngi ];
  };
})
