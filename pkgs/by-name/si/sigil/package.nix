{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  xercesc,
  python3Packages,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "sigil";
  version = "2.4.2";

  src = fetchFromGitHub {
    repo = "Sigil";
    owner = "Sigil-Ebook";
    tag = version;
    hash = "sha256-/lnSNamLkPLG8tn0w8F0zFyypMUXyMhgxA2WyQFegKw=";
  };

  pythonPath = with python3Packages; [ lxml ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    xercesc
    qt6.qtbase
    qt6.qttools
    qt6.qtwebengine
    qt6.qtsvg
    python3Packages.lxml
  ];

  prePatch = ''
    sed -i '/^QTLIB_DIR=/ d' src/Resource_Files/bash/sigil-sh_install
  '';

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p $out/Applications
    mv bin/Sigil.app $out/Applications
    # https://github.com/NixOS/nixpkgs/issues/186653
    chmod -x $out/Applications/Sigil.app/Contents/lib/*.dylib \
      $out/Applications/Sigil.app/Contents/polyfills/*.js \
      $out/Applications/Sigil.app/Contents/python3lib/*.py \
      $out/Applications/Sigil.app/Contents/hunspell_dictionaries/*.{aff,dic}

    runHook postInstall
  '';

  preFixup = ''
    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  meta = {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = "https://github.com/Sigil-Ebook/Sigil/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "sigil";
  };
}
