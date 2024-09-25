{ stdenv, lib, fetchFromGitHub, cmake, qtbase, qttools, qtsvg, qt5compat, quazip
, qtwayland
, hunspell
, wrapQtAppsHook, poppler, zlib, pkg-config }:

stdenv.mkDerivation (finalAttrs: {
  pname = "texstudio";
  version = "4.8.2";

  src = fetchFromGitHub {
    owner = "texstudio-org";
    repo = "texstudio";
    rev = finalAttrs.version;
    hash = "sha256-q6dy9CS8zxMlLC4M76t4RjYlMJyUG55Cb0KREyDfM78=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    pkg-config
  ];
  buildInputs = [
    hunspell
    poppler
    qt5compat
    qtbase
    qtsvg
    qttools
    quazip
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/bin/texstudio.app" "$out/Applications"
    rm -d "$out/bin"
  '';

  meta = with lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
      Fork of TeXMaker, this editor is a full fledged IDE for
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "https://texstudio.org";
    changelog = "https://github.com/texstudio-org/texstudio/blob/${finalAttrs.version}/utilities/manual/source/CHANGELOG.md";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ajs124 cfouche ];
    mainProgram = "texstudio";
  };
})
