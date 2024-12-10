{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  wrapQtAppsHook,
  gst_all_1,
  qtbase,
  qtsvg,
  qtmultimedia,
  qttools,
  qtwayland,
  zlib,
  # only required when using poppler
  poppler,
  # only required when using mupdf
  freetype,
  gumbo,
  jbig2dec,
  mupdf,
  openjpeg,
  # choose renderer: mupdf or poppler or both (not recommended)
  usePoppler ? false,
  useMupdf ? true,
  useExternalRenderer ? false,
}:

stdenv.mkDerivation rec {
  pname = "beamerpresenter";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "stiglers-eponym";
    repo = "BeamerPresenter";
    rev = "v${version}";
    hash = "sha256-UQbyzkFjrIDPcrE6yGuOWsXNjz8jWyJEWiQwHmf91/8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    wrapQtAppsHook
  ];

  dontWrapGApps = true;

  buildInputs =
    [
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      zlib
      qtbase
      qtsvg
      qtmultimedia
      qttools
    ]
    ++ lib.optionals stdenv.isLinux [
      qtwayland
    ]
    ++ lib.optionals useMupdf [
      freetype
      gumbo
      jbig2dec
      mupdf
      openjpeg
    ]
    ++ lib.optionals usePoppler [
      poppler
    ];

  cmakeFlags = [
    "-DGIT_VERSION=OFF"
    "-DUSE_POPPLER=${if usePoppler then "ON" else "OFF"}"
    "-DUSE_MUPDF=${if useMupdf then "ON" else "OFF"}"
    "-DUSE_QTPDF=OFF"
    "-DLINK_MUPDF_THIRD=OFF"
    "-DUSE_EXTERNAL_RENDERER=${if useExternalRenderer then "ON" else "OFF"}"
    "-DLINK_MUJS=OFF"
    "-DLINK_GUMBO=ON"
    "-DUSE_TRANSLATIONS=ON"
    "-DQT_VERSION_MAJOR=${lib.versions.major qtbase.version}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Modular multi screen pdf presentation viewer";
    homepage = "https://github.com/stiglers-eponym/BeamerPresenter";
    license = with licenses; [
      agpl3Only
      gpl3Plus
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [
      pacien
      dotlambda
    ];
    mainProgram = "beamerpresenter";
  };
}
