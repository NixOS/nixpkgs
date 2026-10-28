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
  makeWrapper,
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

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "fltk_jpeg fltk_png fltk_z" "jpeg png z"
  '';

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
    xdg-utils
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

  buildInputs = [
    cairo
    fltk_1_4
    libjpeg
    libpng
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libGLU
    libx11
    libxpm
  ];

  cmakeFlags = [
    (lib.cmakeFeature "BIN_DIR" "bin")
    (lib.cmakeBool "FLTK_SKIP_FLUID" true)
    (lib.cmakeBool "ENABLE_UNIT_TESTS" false)
    (lib.cmakeBool "USE_SYSTEM_FLTK" true)
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev cairo}/include/cairo";

  preInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    export XDG_DATA_HOME=$out/share HOME=$TMPDIR
  '';

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "Eureka Doom Editor.app" $out/Applications/
    makeWrapper "$out/Applications/Eureka Doom Editor.app/Contents/MacOS/Eureka Doom Editor" $out/bin/eureka

    runHook postInstall
  '';

  postInstall = ''
    install -Dm644 ../misc/eureka.6 -t $out/share/man/man6
  '';

  doInstallCheck = !stdenv.hostPlatform.isDarwin;
  nativeInstallCheckInputs = [ versionCheckHook ];

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "eureka";
  };
})
