{ lib, mkDerivation, fetchFromGitHub, fetchpatch
, python3, ruby, qtbase, qtmultimedia, qttools, qtxmlpatterns
, which, perl, makeWrapper
}:

mkDerivation rec {
  pname = "klayout";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    rev = "v${version}";
    sha256 = "sha256-6g/QoR16rhUfxhH4JxL6EERcoPVG/6MOxUlo6K/WoE0=";
  };

  postPatch = ''
    substituteInPlace src/klayout.pri --replace "-Wno-reserved-user-defined-literal" ""
    patchShebangs .
  '';

  nativeBuildInputs = [
    which
    python3
    ruby
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qttools
    qtxmlpatterns
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/lib
    ./build.sh -qt5 -prefix $out/lib -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  postBuild = ''
    mkdir $out/bin
    mv $out/lib/klayout $out/bin/
  '';

  NIX_CFLAGS_COMPILE = [ "-Wno-parentheses" ];

  dontInstall = true; # Installation already happens as part of "build.sh"

  # Fix: "gsiDeclQMessageLogger.cc:126:42: error: format not a string literal
  # and no format arguments [-Werror=format-security]"
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "High performance layout viewer and editor with support for GDS and OASIS";
    license = with licenses; [ gpl3 ];
    homepage = "https://www.klayout.de/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ knedlsepp ];
  };
}

