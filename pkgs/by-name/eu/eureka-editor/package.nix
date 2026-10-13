{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
  cmake,
  fltk_1_4,
  libGL,
  libGLU,
  libjpeg,
  libpng,
  libx11,
  libxpm,
  nix-update-script,
  versionCheckHook,
  wrapGAppsHook3,
  xdg-utils,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eureka-editor";
  version = "2.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ioan-chera";
    repo = "eureka-editor";
    tag = "eureka-${finalAttrs.version}";
    hash = "sha256-MwFa/AKFj+jV3W9YUuao4gqQbBuuyeS9dkS1IoPb0+4=";
  };

  nativeBuildInputs = [
    cmake
    wrapGAppsHook3
    xdg-utils
  ];

  buildInputs = [
    cairo
    fltk_1_4
    libGL
    libGLU
    libjpeg
    libpng
    libx11
    libxpm
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "BIN_DIR" "bin")
    (lib.cmakeBool "FLTK_SKIP_FLUID" true)
    (lib.cmakeBool "ENABLE_UNIT_TESTS" false)
    (lib.cmakeBool "USE_SYSTEM_FLTK" true)
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev cairo}/include/cairo";

  preInstall = ''
    export XDG_DATA_HOME=$out/share HOME=$TMPDIR
  '';

  postInstall = ''
    install -Dm644 ../misc/eureka.6 -t $out/share/man/man6
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  preFixup = ''
    gappsWrapperArgs+=(--add-flags "--install $out/share/eureka")
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "eureka-(.*)"
    ];
  };

  meta = {
    description = "Map editor for the classic DOOM games, and a few related games such as Heretic and Hexen";
    homepage = "https://eureka-editor.sourceforge.net";
    changelog = "https://github.com/ioan-chera/eureka-editor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
    mainProgram = "eureka";
  };
})
