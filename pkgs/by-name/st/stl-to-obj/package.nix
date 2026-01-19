{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stl-to-obj";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Neizvestnyj";
    repo = "stl-to-obj";
    rev = finalAttrs.version;
    hash = "sha256-+R7rNpMxKFC7sLYQXZX3Ikb5MqNd57r1M8gma73kCcg=";
  };

  postPatch = ''
    # Add missing cstdint include
    # ref. https://github.com/Neizvestnyj/stl-to-obj/pull/12
    for filename in \
      stl2obj/src/mode.cpp \
      stl2obj/src/obj_to_stl/StlWriter.cpp \
      stl2obj/src/stl_to_obj/importstl.cpp \
      stl2obj/src/stl_to_obj/kdtree.h
    do
      echo "$(echo '#include <cstdint>'; cat $filename)" > $filename
    done

    # Install main executable
    # ref. https://github.com/Neizvestnyj/stl-to-obj/pull/13
    echo "install(TARGETS stl2obj DESTINATION $""{CMAKE_INSTALL_BINDIR})" >> CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "C++ stl to obj file converter and vice versa";
    homepage = "https://github.com/Neizvestnyj/stl-to-obj";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "stl2obj";
    platforms = lib.platforms.all;
  };
})
