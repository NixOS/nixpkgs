{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,
  unstableGitUpdater,

  quickjs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quickjspp";
  version = "0-unstable-2025-07-04";

  src = fetchFromGitHub {
    owner = "ftk";
    repo = "quickjspp";
    rev = "01cdd3047ced48265b127790848a0ca88204f2c7";
    hash = "sha256-mjnkbx/6DT0MXdeqA/2/CaMQy/iAUjIaGJT1Oi+JEqg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [ quickjs ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "QuickJS C++ wrapper";
    homepage = "https://github.com/ftk/quickjspp";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
