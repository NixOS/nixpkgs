{ stdenv, fetchurl, unzip, cmake, pkgconfig, makeWrapper
, hunspell, minizip, boost, xercesc
, qtbase, qttools, qtwebkit, qtxmlpatterns
}:

let
  version = "0.7.4";

in

stdenv.mkDerivation rec {
  name = "sigil-${version}";

  src = fetchurl {
    url = "https://sigil.googlecode.com/files/Sigil-${version}-Code.zip";
    sha256 = "68c7ca15ea8611921af0c435369563f55c6afd2ef1fb0945cf6c4a47429b0fb5";
  };

  buildInputs = [
    unzip cmake pkgconfig
    hunspell minizip boost xercesc qtbase qttools qtwebkit qtxmlpatterns
  ];

  # XXX: the compiler seems to treat the .h file inappropriately:
  #
  #    COMMAND ${CMAKE_CXX_COMPILER} ${compile_flags} \
  #            ${CMAKE_CURRENT_SOURCE_DIR}/${header_name}.h \
  #           -o ${header_name}.h.gch
  #
  #  but using -c or -x c++-header seems to work:
  #
  #    COMMAND ${CMAKE_CXX_COMPILER} ${compile_flags} \
  #            -c ${CMAKE_CURRENT_SOURCE_DIR}/${header_name}.h \
  #            -o ${header_name}.h.gch
  #
  #    COMMAND ${CMAKE_CXX_COMPILER} ${compile_flags} \
  #            -x c++-header ${CMAKE_CURRENT_SOURCE_DIR}/${header_name}.h \
  #            -o ${header_name}.h.gch
  #
  # Might be related to:
  #
  #   http://permalink.gmane.org/gmane.comp.gcc.bugs/361195
  buildCommand = ''
    mkdir -pv $out
    mkdir -pv ${name}/src ${name}/build ${name}/run
    cd ${name}/src
    unzip -n ${src}
    sed -i \
        -e 's|\(COMMAND\) \([^ ]\+\) \([^ ]\+\) \(.*\)|\1 \2 \3 -c \4|' \
        cmake_extras/CustomPCH.cmake
    cd ../build
    cmake -G "Unix Makefiles" \
        -DCMAKE_INSTALL_PREFIX=$out \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_SKIP_BUILD_RPATH=ON \
        ../src
    make
    make install
  '';

  meta = {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = https://code.google.com/p/sigil/;
    license = stdenv.lib.licenses.gpl3;
    inherit version;
  };
}
