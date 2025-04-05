{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  libgpod,
  wxGTK32,
  sqlite,
  curl,
  taglib,
  wxsqlite3,
  jsoncpp,
  icu,
  gst_all_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guayadeque";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "thothix";
    repo = "guayadeque";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nF1fBJlZp2RpapIcs+tmPQNHobYqIU8Ps5H/01zAyV0=";
  };

  # cmake tries to create a directory with the same name
  postPatch = ''
    rm build
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libgpod
    wxGTK32
    sqlite
    curl
    taglib
    wxsqlite3
    jsoncpp
    icu
    gst_all_1.gstreamer
    gst_all_1.gstreamermm
  ];

  cmakeFlags = [ "-DCMAKE_CXX_STANDARD=11" ];

  meta = {
    description = "Full Featured Linux media player that can easily manage large collections";
    longDescription = ''
      Guayadeque is a music management program designed for
      all music enthusiasts. It is Full Featured Linux media
      player that can easily manage large collections and
      uses the Gstreamer media framework.
    '';
    homepage = "https://www.guayadeque.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
