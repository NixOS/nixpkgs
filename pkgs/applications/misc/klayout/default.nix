{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  libsForQt5,
  qt6Packages,
  python3,
  python3Packages,
  ruby,
  which,
  perl,
  libgit2,
  libpng,
  expat,
  curl,
  zlib,
  withQt6 ? true,
}:

let
  qtPackages = if withQt6 then qt6Packages else libsForQt5;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "klayout";
  version = "0.30.8";

  src = fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RjMH6hrc0jyCLgG1D6cztBp5Fb3W5HgTxVTfI2bxgCs=";
  };

  strictDeps = true;

  postPatch = ''
    patchShebangs --build .
  '';

  dontUseQmakeConfigure = true;
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  nativeBuildInputs =
    with qtPackages;
    [
      (python3.withPackages (ps: [ ps.tomli ]))
      installShellFiles
      perl
      ruby
      which
      wrapQtAppsHook
      qmake
      qtbase
      qtmultimedia
      qtsvg
      qttools
    ]
    ++ lib.optionals withQt6 [
      qt5compat
    ]
    ++ lib.optionals (!withQt6) [
      qtxmlpatterns
    ];

  buildInputs =
    with qtPackages;
    [
      qtbase
      qtmultimedia
      qtsvg
      qttools
      libgit2
      libpng
      expat
      curl
      zlib
    ]
    ++ lib.optionals withQt6 [
      qt5compat
    ]
    ++ lib.optionals (!withQt6) [
      qtxmlpatterns
    ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/lib

    ./build.sh \
      -prefix $out/lib \
      -option "-j$NIX_BUILD_CORES" \
      -rpath $out/lib \
      -libpng \
      -libcurl \
      -libexpat

    runHook postBuild
  '';

  postBuild =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm444 etc/klayout.desktop -t $out/share/applications
      install -Dm444 etc/logo.png $out/share/icons/hicolor/256x256/apps/klayout.png

      installBin $out/lib/klayout
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv $out/lib/klayout.app $out/Applications/
    '';

  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    exec_name=$out/Applications/klayout.app/Contents/MacOS/klayout

    for lib in $out/lib/libklayout_*.0.dylib; do
      base_name=$(basename $lib)
      install_name_tool -change "$base_name" "@rpath/$base_name" "$exec_name"
    done

    wrapQtApp "$out/Applications/klayout.app/Contents/MacOS/klayout"
  '';

  env = {
    NIX_CFLAGS_COMPILE = toString [ "-Wno-parentheses" ];
    NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";
  };

  # Installation is handled manually in buildPhase/postBuild via build.sh -prefix
  dontInstall = true;

  # Fix for: "gsiDeclQMessageLogger.cc: error: format not a string literal"
  hardeningDisable = [ "format" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      pythonPackage = python3Packages.klayout;
    };
  };

  meta = {
    description = "High performance layout viewer and editor with support for GDS and OASIS";
    mainProgram = "klayout";
    license = with lib.licenses; [ gpl2Plus ];
    homepage = "https://www.klayout.de/";
    changelog = "https://www.klayout.de/development.html#${finalAttrs.version}";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
})
