{
  lib,
  testers,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "faac";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faac";
    tag = "faac-${finalAttrs.version}";
    hash = "sha256-+t8NNPaNlGXeDylEeBupOe5fbI1BD7JKDzdCRxRu52c=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonFlags = [
    (lib.mesonBool "b_lto" false) # plugin needed to handle lto object
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      # tag is "faac-2.1", but specified meson project version is "2.1.0"
      versionCheck = false;
    };
  };

  meta = {
    changelog = "https://github.com/knik0/faac/releases/tag/${finalAttrs.src.tag}";
    description = "Open source MPEG-4 and MPEG-2 AAC encoder";
    homepage = "https://github.com/knik0/faac";
    pkgConfigModules = [ "faac" ];
    mainProgram = "faac";
    license = with lib.licenses; [
      # faac itself
      lgpl21Plus
      # frontend/getopt.h
      isc
      # frontend/getopt.c
      bsd2
      publicDomain
    ];
    maintainers = with lib.maintainers; [ tmarkus ];
    platforms = lib.platforms.all;
  };
})
