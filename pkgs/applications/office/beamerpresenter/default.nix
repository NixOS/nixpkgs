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
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "stiglers-eponym";
    repo = "BeamerPresenter";
    rev = "v${version}";
    hash = "sha256-sPeWlPkWOPfLAoAC/+T7nyhPqvoaZg6aMOIVLjMqd2k=";
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
    ++ lib.optionals stdenv.hostPlatform.isLinux [
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
    (lib.cmakeBool "GIT_VERSION" false)
    (lib.cmakeBool "USE_POPPLER" usePoppler)
    (lib.cmakeBool "USE_MUPDF" useMupdf)
    (lib.cmakeBool "USE_QTPDF" false)
    (lib.cmakeBool "LINK_MUPDF_THIRD" false)
    (lib.cmakeBool "USE_EXTERNAL_RENDERER" useExternalRenderer)
    (lib.cmakeBool "LINK_MUJS" false)
    (lib.cmakeBool "LINK_GUMBO" true)
    (lib.cmakeBool "USE_TRANSLATIONS" true)
    (lib.cmakeFeature "QT_VERSION_MAJOR" (lib.versions.major qtbase.version))
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
      euxane
      dotlambda
    ];
    mainProgram = "beamerpresenter";
  };
}
