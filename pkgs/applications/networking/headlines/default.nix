{ lib
, stdenv
, cmake
, pkg-config
, libmicrohttpd
, curl
, openssl
, jsoncpp
, libxml2
, gst_all_1
, boost
, websocketpp
, libadwaita
, gtkmm4
, libsecret
, fetchFromGitLab
, makeWrapper
, xdg-utils
, youtube-dl
, ffmpeg
}:

stdenv.mkDerivation rec {
  pname = "headlines";
  version = "0.7.2";

  src = fetchFromGitLab {
    owner = "caveman250";
    repo = "Headlines";
    rev = version;
    sha256 = "sha256-wamow0UozX5ecKbXWOgsWCerInL4J0gK0+Muf+eoO9k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
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
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ]);

  postFixup = ''
    wrapProgram "$out/bin/headlines" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils youtube-dl ffmpeg ]}" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
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
