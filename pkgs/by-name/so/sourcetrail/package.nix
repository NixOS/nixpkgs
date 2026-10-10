# https://github.com/NixOS/nixpkgs/blob/9341cd89e90b0d8c98f803ee5ce132e043454ce0/pkgs/development/tools/sourcetrail/default.nix#L19
{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  jdk_headless,
  jre_headless,
  boost186,
  llvmPackages,
  gcc,
  maven,
  which,
  desktop-file-utils,
  shared-mime-info,
  imagemagick,
  tinyxml,
}:
let
  boost = boost186;
  javaIndexer = callPackage ./java.nix { };
in
stdenv.mkDerivation rec {
  pname = "sourcetrail";
  version = "2025.3.3";

  src = fetchFromGitHub {
    owner = "petermost";
    repo = "Sourcetrail";
    rev = version;
    sha256 = "sha256-JP+m6p1LT9N9aCZHYVhPY2G16uKQRqLybl2qbfMtyzw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    jdk_headless
    maven
    desktop-file-utils
    imagemagick
  ];

  buildInputs = [
    boost
    tinyxml
    shared-mime-info
    qt6.qtbase
    qt6.qtsvg
    llvmPackages.libclang
    llvmPackages.llvm
  ];

  # Do we need these?
  binPath = [
    gcc
    jre_headless
    maven
    which
  ];

  patches = [ ./build-java.patch ];

  patchFlags = "-p1";

  cmakeFlags = [
    "-DBUILD_CXX_LANGUAGE_PACKAGE=ON"
    "-DBUILD_JAVA_LANGUAGE_PACKAGE=ON"
    # Prototype state: https://github.com/petermost/Sourcetrail/blob/e8c201e116e5cb44c3360507d3af43ef928ffb29/CMakeLists.txt#L345
    # "-DBUILD_PYTHON_LANGUAGE_PACKAGE=ON"
    "-DCMAKE_PREFIX_PATH=${llvmPackages.clang-unwrapped}"
  ];

  postPatch = ''
    # Sourcetrail attempts to copy clang headers from the LLVM store path
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${headerSourceDir}" \
      '${lib.getLib llvmPackages.clang-unwrapped}'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -R ./app $out/opt/sourcetrail

    mkdir -p $out/bin
    makeQtWrapper $out/opt/sourcetrail/Sourcetrail $out/bin/sourcetrail \
      --prefix PATH : ${lib.makeBinPath binPath}

    mkdir -p $out/opt/sourcetrail/data/java/lib/
    cp ${javaIndexer}/* $out/opt/sourcetrail/data/java/lib/

    desktop-file-install --dir=$out/share/applications \
      --set-key Exec --set-value $out/bin/sourcetrail \
      ../unused_coati_software_files/setup/Linux/data/sourcetrail.desktop

    mkdir -p $out/share/mime/packages
    cp ../unused_coati_software_files/setup/Linux/data/sourcetrail-mime.xml \
      $out/share/mime/packages/

    for size in 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps/
      magick ./app/data/gui/icon/logo_1024_1024.png \
        -resize ''${size}x''${size} \
        $out/share/icons/hicolor/''${size}x''${size}/apps/sourcetrail.png
    done

    runHook postInstall
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Free and open-source interactive source explorer";
    homepage = "https://sourcetrail.de";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eownerdead ];
    mainProgram = "sourcetrail";
    # https://github.com/petermost/Sourcetrail/blob/5a7a4599522e54a0f9ec463ecf9b4c312c5765f6/src/lib/utility/Platform.cpp#L8
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
