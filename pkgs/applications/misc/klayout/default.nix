{
  lib,
  mkDerivation,
  fetchFromGitHub,
  python3,
  ruby,
  qtbase,
  qtmultimedia,
  qttools,
  qtxmlpatterns,
  which,
  perl,
  libgit2,
  stdenv,
}:

mkDerivation rec {
  pname = "klayout";
  version = "0.30.4-1";

  src = fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    rev = "v${version}";
    hash = "sha256-EhIGxiXqo09/p8mA00RRvKgXJncVr4qguYSPyEC0fqc=";
  };

  postPatch = ''
    substituteInPlace src/klayout.pri --replace "-Wno-reserved-user-defined-literal" ""
    patchShebangs .
  '';

  nativeBuildInputs = [
    which
    perl
    python3
    ruby
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
    ./build.sh -qt5 -prefix $out/lib -option -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  postBuild =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir $out/bin

      install -Dm444 etc/klayout.desktop -t $out/share/applications
      install -Dm444 etc/logo.png $out/share/icons/hicolor/256x256/apps/klayout.png
      mv $out/lib/klayout $out/bin/
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

  dontInstall = true; # Installation already happens as part of "build.sh"

  # Fix: "gsiDeclQMessageLogger.cc:126:42: error: format not a string literal
  # and no format arguments [-Werror=format-security]"
  hardeningDisable = [ "format" ];

  meta = {
    description = "High performance layout viewer and editor with support for GDS and OASIS";
    mainProgram = "klayout";
    license = with lib.licenses; [ gpl2Plus ];
    homepage = "https://www.klayout.de/";
    changelog = "https://www.klayout.de/development.html#${version}";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ];
  };
}
