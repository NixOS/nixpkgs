{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  gst_all_1,
  zlib,
  qt6,
  qt6Packages,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "beamerpresenter";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "beamerpresenter";
    repo = "BeamerPresenter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sPeWlPkWOPfLAoAC/+T7nyhPqvoaZg6aMOIVLjMqd2k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    qt6.wrapQtAppsHook
  ];

  dontWrapGApps = true;

  buildInputs = [
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    zlib
    qt6.qtbase
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qttools
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ]
  ++ lib.optionals useMupdf [
    freetype
    gumbo
    jbig2dec
    mupdf
    openjpeg
  ]
  ++ lib.optionals usePoppler [
    qt6Packages.poppler
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
    "-DQT_VERSION_MAJOR=${lib.versions.major qt6.qtbase.version}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Modular multi screen pdf presentation viewer";
    homepage = "https://github.com/beamerpresenter/BeamerPresenter";
    license = with lib.licenses; [
      agpl3Only
      gpl3Plus
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      euxane
      dotlambda
    ];
    mainProgram = "beamerpresenter";
  };
})
