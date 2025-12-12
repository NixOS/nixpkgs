{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  kdePackages,
  withGstreamer ? true,
  gst_all_1,
  withOmemo ? true,
  libomemo-c,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qxmpp";
  version = "1.12.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "qxmpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-soOu6JyS/SEdwUngOUd0suImr70naZms9Zy2pRwBn5E=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsNoGuiHook
  ]
  ++ lib.optionals (withGstreamer || withOmemo) [
    pkg-config
  ];
  buildInputs =
    lib.optionals withGstreamer (
      with gst_all_1;
      [
        gstreamer
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
      ]
    )
    ++ lib.optionals withOmemo [
      kdePackages.qtbase
      kdePackages.qca
      libomemo-c
    ];
  cmakeFlags = [
    "-DBUILD_EXAMPLES=false"
    "-DBUILD_TESTS=false"
  ]
  ++ lib.optionals withGstreamer [
    "-DWITH_GSTREAMER=ON"
  ]
  ++ lib.optionals withOmemo [
    "-DBUILD_OMEMO=ON"
  ];

  meta = {
    description = "Cross-platform C++ XMPP client and server library";
    homepage = "https://invent.kde.org/libraries/qxmpp";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ astro ];
    platforms = with lib.platforms; linux;
  };
})
