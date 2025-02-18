{
  lib,
  stdenv,
  cmake,
  pkg-config,
  libmicrohttpd,
  curl,
  openssl,
  jsoncpp,
  libxml2,
  gst_all_1,
  boost,
  websocketpp,
  libadwaita,
  gtkmm4,
  libsecret,
  fetchFromGitLab,
  wrapGAppsHook4,
  xdg-utils,
  youtube-dl,
  ffmpeg,
}:

stdenv.mkDerivation rec {
  pname = "headlines";
  version = "0.7.2";

  src = fetchFromGitLab {
    owner = "caveman250";
    repo = "Headlines";
    rev = version;
    hash = "sha256-wamow0UozX5ecKbXWOgsWCerInL4J0gK0+Muf+eoO9k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [
      libmicrohttpd
      curl
      openssl
      jsoncpp
      libxml2
      boost
      websocketpp
      libadwaita
      gtkmm4
      libsecret
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-libav
      gst-plugins-base
      (gst-plugins-good.override { gtkSupport = true; })
      gst-plugins-bad
    ]);

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          xdg-utils
          youtube-dl
          ffmpeg
        ]
      }"
    )
  '';

  meta = with lib; {
    description = "GTK4 / Libadwaita Reddit client written in C++";
    homepage = "https://gitlab.com/caveman250/Headlines";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chuangzhu ];
    mainProgram = "headlines";
  };
}
