{ lib, mkDerivation, fetchFromGitHub
, python3, ruby, qtbase, qtmultimedia, qttools, qtxmlpatterns
, which, perl, libgit2
}:

mkDerivation rec {
  pname = "klayout";
  version = "0.29.10";

  src = fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    rev = "v${version}";
    hash = "sha256-3YRWGIfBGgN3vlBlFoVbMWgkhoxs7OQli1qtKUXf0KA=";
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

  postBuild = ''
    mkdir $out/bin
    mv $out/lib/klayout $out/bin/

    install -Dm444 etc/klayout.desktop -t $out/share/applications
    install -Dm444 etc/logo.png $out/share/icons/hicolor/256x256/apps/klayout.png
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-parentheses" ];

  dontInstall = true; # Installation already happens as part of "build.sh"

  # Fix: "gsiDeclQMessageLogger.cc:126:42: error: format not a string literal
  # and no format arguments [-Werror=format-security]"
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "High performance layout viewer and editor with support for GDS and OASIS";
    mainProgram = "klayout";
    license = with licenses; [ gpl2Plus ];
    homepage = "https://www.klayout.de/";
    changelog = "https://www.klayout.de/development.html#${version}";
    platforms = platforms.linux;
    maintainers = with maintainers; [ knedlsepp ];
  };
}

