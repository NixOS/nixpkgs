{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qhexedit2";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "Simsys";
    repo = "qhexedit2";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-qg8dyXwAsTVSx85Ad7UYhr4d1aTRG9QbvC0uyOMcY8g=";
  };

  postPatch = ''
    # Replace QPallete::Background with QPallete::Window in all files
    find . -type f -exec sed -i 's/QPalette::Background/QPalette::Window/g' {} +
  '';

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qttools
  ];

  qmakeFlags = [
    "./example/qhexedit.pro"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/include

    # Copy all .o files to $out/lib
    for file in $(find . -name '*.o'); do
      cp $file $out/lib
    done

    # Copy all .so files to $out/lib
    for file in $(find . -name '*.so'); do
      cp $file $out/lib
    done

    # Copy all .cpp files to $out/include
    for file in $(find . -name '*.cpp'); do
      cp $file $out/include
    done

    # Copy all .h files to $out/include
    for file in $(find . -name '*.h'); do
      cp $file $out/include
    done

    # Copy qhexedit to $out/bin
    cp qhexedit $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Hex Editor for Qt";
    homepage = "https://github.com/Simsys/qhexedit2";
    mainProgram = "qhexedit";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
