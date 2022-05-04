{ lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  cmake,
  qtbase,
  qtmultimedia,
  qttools,
  wrapQtAppsHook,
  bash,
  zlib,
  gcc,
  gnumake,
  coreutils,
  # only required when using poppler
  poppler,
  # only required when using mupdf
  mupdf,
  freetype,
  jbig2dec,
  openjpeg,
  gumbo,
  # choose renderer: mupdf or poppler or both (not recommended)
  renderer ? "mupdf",
  # choose major Qt version: "5" or "6" (only 5 is tested)
  qt_version ? "5"}:

let
  renderers = {
    mupdf.buildInputs = [ mupdf freetype jbig2dec openjpeg gumbo ];
    poppler.buildInputs = [ poppler ];
  };
  use_poppler = if "${renderer}" == "poppler" || "${renderer}" == "both" then "ON" else "OFF";
  use_mupdf = if "${renderer}" == "mupdf" || "${renderer}" == "both" then "ON" else "OFF";
in

stdenv.mkDerivation rec {
  pname = "beamerpresenter";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "stiglers-eponym";
    repo = "BeamerPresenter";
    rev = "v${version}";
    sha256 = "16v263nnnipih3lxg95rmwz0ihnvpl4n1wlj9r6zavnspzlp9dvb";
  };

  nativeBuildInputs = [ pkg-config installShellFiles wrapQtAppsHook ];
  buildInputs = [ gcc cmake coreutils gnumake bash zlib qtbase qtmultimedia qttools ] ++ renderers.${renderer}.buildInputs;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='Release'"
    "-DGIT_VERSION=OFF"
    "-DUSE_POPPLER=${use_poppler}"
    "-DUSE_MUPDF=${use_mupdf}"
    "-DUSE_MUJS=OFF"
    "-DUSE_GUMBO=ON"
    "-DUSE_TRANSLATIONS=ON"
    "-DQT_VERSION_MAJOR=${qt_version}"
  ];

  meta = with lib; {
    description = "Modular multi screen pdf presentation viewer";
    homepage = "https://github.com/stiglers-eponym/BeamerPresenter";
    license = with licenses; [ agpl3 gpl3Plus ];
    platforms = platforms.all;
    maintainers = with maintainers; [ pacien ];
  };
}
