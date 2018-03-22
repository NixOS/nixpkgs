{ stdenv, fetchurl, cmake, qt5, zlib, taglib, pkgconfig, pcre, gst_all_1 }:

let
  version = "1.0.0-git5-20180115";
in
stdenv.mkDerivation {
  name = "sayonara-player-${version}";

  src = fetchurl {
    url = "https://sayonara-player.com/sw/sayonara-player-${version}.tar.gz";
    sha256 = "1fl7zplnrrvbv1xm4g348bpd46jj39jvbm808hyjjq92i64wqg37";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = with qt5; with gst_all_1;
      [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly
        pcre qtbase qttools taglib zlib
      ];

  # CMake Error at src/GUI/Resources/Icons/cmake_install.cmake:49 (file):
  #   file cannot create directory: /usr/share/icons.  Maybe need administrative
  #   privileges.
  # Call Stack (most recent call first):
  #   src/GUI/Resources/cmake_install.cmake:50 (include)
  #   src/GUI/cmake_install.cmake:50 (include)
  #   src/cmake_install.cmake:59 (include)
  #   cmake_install.cmake:42 (include)
  postPatch = ''
    substituteInPlace src/GUI/Resources/Icons/CMakeLists.txt \
      --replace "/usr/share" "$out/share"
  '';

  # [ 65%] Building CXX object src/Components/Engine/CMakeFiles/say_comp_engine.dir/AbstractPipeline.cpp.o
  # /tmp/nix-build-sayonara-player-1.0.0-git5-20180115.drv-0/sayonara-player/src/Components/Engine/AbstractPipeline.cpp:28:32: fatal error: gst/app/gstappsink.h: No such file or directory
  #  #include <gst/app/gstappsink.h>
  NIX_CFLAGS_COMPILE = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

  meta = with stdenv.lib;
    { description = "Sayonara music player";
      homepage = https://sayonara-player.com/;
      license = licenses.gpl3;
      platforms = qt5.qtbase.meta.platforms;
      maintainers = [ maintainers.deepfire ];
    };
}
