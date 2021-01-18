{ mkDerivation
, cmake
, fetchFromGitLab
, gst_all_1
, lib
, libpulseaudio
, ninja
, pcre
, pkg-config
, qtbase
, qttools
, taglib
, zlib
}:

mkDerivation rec {
  pname = "sayonara-player";
  version = "1.6.0-beta6";

  src = fetchFromGitLab {
    owner = "luciocarreras";
    repo = "sayonara-player";
    rev = version;
    sha256 = "sha256-SbJS0DQvbW++CNXbuDHQxFlLRb1kTtDdIdHOqu0YxeQ=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config qttools ];

  buildInputs = [
    libpulseaudio
    pcre
    qtbase
    taglib
    zlib
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  # we carry the patched taglib 1.11.1 that doesn't break ogg but sayonara just
  # checks for the version
  cmakeFlags = [
    "-DWITH_SYSTEM_TAGLIB=ON"
  ];

  # gstreamer cannot otherwise be found
  NIX_CFLAGS_COMPILE = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Sayonara music player";
    homepage = "https://sayonara-player.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ deepfire ];
    platforms = platforms.unix;
  };
}
