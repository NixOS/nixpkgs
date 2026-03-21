{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  python3,
  ruby,
  wrapQtAppsHook,
  qtbase,
  qtmultimedia,
  qttools,
  qtxmlpatterns,
  which,
  perl,
  libgit2,
}:

stdenv.mkDerivation rec {
  pname = "klayout";
  version = "0.30.5";

  src = fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    rev = "v${version}";
    hash = "sha256-WigRictn6CxOPId2YitlEm43vEw+dSRWdoareD9HtMc=";
  };

  postPatch = ''
    substituteInPlace src/klayout.pri --replace "-Wno-reserved-user-defined-literal" ""
    patchShebangs .
  '';

  nativeBuildInputs = [
    (python3.withPackages (ps: [ ps.tomli ]))
    installShellFiles
    perl
    ruby
    which
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qttools
    qtxmlpatterns
    libgit2
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/lib

    # -qt5: Using Qt5 as per your previous configuration.
    # -rpath: Ensures the klayout binary can find its internal libraries (tl, db, etc.)
    #         in the nix store without needing LD_LIBRARY_PATH.
    ./build.sh \
      -qt5 \
      -prefix $out/lib \
      -option "-j$NIX_BUILD_CORES" \
      -rpath $out/lib

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

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-parentheses" ];

  # Installation is handled manually in buildPhase/postBuild via build.sh -prefix
  dontInstall = true;

  # Fix for: "gsiDeclQMessageLogger.cc: error: format not a string literal"
  hardeningDisable = [ "format" ];

  meta = {
    description = "High performance layout viewer and editor with support for GDS and OASIS";
    mainProgram = "klayout";
    license = with lib.licenses; [ gpl2Plus ];
    homepage = "https://www.klayout.de/";
    changelog = "https://www.klayout.de/development.html#${version}";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
}
