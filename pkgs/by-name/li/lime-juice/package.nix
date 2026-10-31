{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  testers,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lime-juice";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "FuzionCD";
    repo = "lime-juice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0KOzqpeQQleMkJUpWLHA5ZhqSxy8iD0Tj6gdCPM+itA=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "C++ port of Tomyun's 'Juice' de/recompiler for PC-98 games using the ADV engine";
    homepage = "https://github.com/FuzionCD/lime-juice";
    license = lib.licenses.gpl3Plus;
    mainProgram = "juice";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix;
  };
})
