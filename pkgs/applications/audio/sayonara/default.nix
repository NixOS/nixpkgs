{ mkDerivation
, cmake
, fetchgit
, gst_all_1
, lib
, libpulseaudio
, ninja
, pcre
, pkgconfig
, qtbase
, qttools
, taglib
, zlib
}:

mkDerivation rec {
  pname = "sayonara-player";
  version = "1.5.1-stable5";

  src = fetchgit {
    url = "https://git.sayonara-player.com/sayonara.git";
    rev = version;
    sha256 = "13l7r3gaszrkyf4z8rdijfzxvcnilax4ki2mcm30wqk8d4g4qdzj";
  };

  # all this can go with version 1.5.2
  postPatch = ''
    # if we don't delete this, sayonara will look here instead of the provided taglib
    rm -r src/3rdParty/taglib

    for f in \
      src/DBus/DBusNotifications.cpp \
      src/Gui/Resources/Icons/CMakeLists.txt \
      src/Utils/Utils.cpp \
      test/Util/FileHelperTest.cpp \
      ; do

      substituteInPlace $f --replace /usr $out
    done

    substituteInPlace src/Components/Shutdown/Shutdown.cpp \
      --replace /usr/bin/systemctl systemctl
  '';

  nativeBuildInputs = [ cmake ninja pkgconfig qttools ];

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
