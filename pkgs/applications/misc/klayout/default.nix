{ lib, mkDerivation, fetchFromGitHub, fetchpatch
, python, ruby, qtbase, qtmultimedia, qttools, qtxmlpatterns
, which, perl, makeWrapper, fixDarwinDylibNames
}:

mkDerivation rec {
  pname = "klayout";
  version = "0.26.5";

  src = fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    rev = "v${version}";
    sha256 = "1zv8yazhdyxm33vdn0m5cciw7zzg45nwdg4rdcsydnrwg7d667r6";
  };

  postPatch = ''
    substituteInPlace src/klayout.pri --replace "-Wno-reserved-user-defined-literal" ""
    patchShebangs .
  '';

  nativeBuildInputs = [
    which
  ];

  buildInputs = [
    python
    ruby
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

