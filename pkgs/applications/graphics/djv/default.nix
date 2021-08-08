{ stdenv
, cmake
, fetchFromGitHub
, lib
, alsa-lib
, libGL
, libX11
, libXinerama
, libXi
, zlib
, rtaudio
, rapidjson
, ilmbase
, glm
, glfw3
, libpng
, opencolorio_1
, freetype
}:

let

  # The way third-party dependencies are packaged has changed
  # significantly from the 2.0.8 release. This means any packaging
  # effort for the 2.0.8 release would have to be redone for the next
  # release. Hence we package the git version for now and can easily
  # jump onto the next release once it's available.
  djvVersion = "2.0.8-unstable-2021-07-31";

  djvSrc = fetchFromGitHub {
    owner = "darbyjohnston";
    repo = "djv";
    rev = "ae31712c4f2802a874217ac194bde26287993934";
    sha256 = "1qgia6vqb6fhyfj8w925xl6k6zidrp2gj5f32bpi94lwwhi6p9pd";
  };

  # DJV's build system tries to automatically pull in FSeq, another
  # library by the DJV author.
  #
  # When updating, check the following file in the DJV source:
  # etc/SuperBuild/cmake/Modules/BuildFSeq.cmake
  #
  # If there is revision or tag specified, DJV wants to use the most
  # recent master version
  fseqSrc = fetchFromGitHub {
    owner = "darbyjohnston";
    repo = "fseq";
    rev = "545fac6018100f7fca474b8ee4f1efa7cbf6bf45";
    sha256 = "0qfhbrzji05hh5kwgd1wvq2lbf81ylbi7v7aqk28aws27f8d2hk0";
  };

  djv-deps = stdenv.mkDerivation rec {
    pname = "djv-dependencies";
    version = djvVersion;

    src = djvSrc;

    sourceRoot = "source/etc/SuperBuild";

    nativeBuildInputs = [ cmake ];
    buildInputs = [
      libGL
    ];

    postPatch = ''
      chmod -R +w .

      sed -i 's,GIT_REPOSITORY https://github.com/darbyjohnston/FSeq.git,SOURCE_DIR ${fseqSrc},' \
          cmake/Modules/BuildFSeq.cmake

      # We pull these projects in as normal Nix dependencies. No need
      # to build them again here.

      sed -i CMakeLists.txt \
          -e '/list(APPEND DJV_THIRD_PARTY_DEPS RapidJSON)/d' \
          -e '/list(APPEND DJV_THIRD_PARTY_DEPS RtAudio)/d' \
          -e '/list(APPEND DJV_THIRD_PARTY_DEPS IlmBase)/d' \
          -e '/list(APPEND DJV_THIRD_PARTY_DEPS GLM)/d' \
          -e '/list(APPEND DJV_THIRD_PARTY_DEPS GLFW)/d' \
          -e '/list(APPEND DJV_THIRD_PARTY_DEPS ZLIB)/d' \
          -e '/list(APPEND DJV_THIRD_PARTY_DEPS PNG)/d' \
          -e '/list(APPEND DJV_THIRD_PARTY_DEPS FreeType)/d' \
          -e '/list(APPEND DJV_THIRD_PARTY_DEPS OCIO)/d'

      # The "SuperBuild" wants to build DJV right here. This is
      # inconvenient, because then the `make install` target is not generated
      # by CMake. We build DJV in its own derivation below. This also makes
      # the build a bit more modular.

      sed -i '/include(BuildDJV)/d' \
          CMakeLists.txt
    '';

    cmakeFlags = [
      "-DDJV_THIRD_PARTY_OpenEXR:BOOL=False"
      "-DDJV_THIRD_PARTY_JPEG:BOOL=False"
      "-DDJV_THIRD_PARTY_TIFF:BOOL=False"
    ];

    dontInstall = true;
    doCheck = true;
  };

in
stdenv.mkDerivation rec {
  pname = "djv";
  version = djvVersion;

  src = djvSrc;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    alsa-lib
    libGL
    libX11
    libXinerama
    libXi
    rapidjson
    rtaudio
    ilmbase
    glm
    glfw3
    zlib.dev
    libpng
    freetype
    opencolorio_1
    djv-deps
  ];

  postPatch = ''
    chmod -R +w .

    # When linking opencolorio statically this results in failing to
    # pull in opencolorio's dependencies (tixml and yaml libraries). Avoid
    # this by linking it statically instead.

    sed -i cmake/Modules/FindOCIO.cmake \
        -e 's/PATH_SUFFIXES static//' \
        -e '/OpenColorIO_STATIC/d'
  '';

  # GLFW requires a working X11 session.
  doCheck = false;

  meta = with lib; {
    description = "A professional review software for VFX, animation, and film production";
    homepage = "https://darbyjohnston.github.io/DJV/";
    platforms = platforms.linux;
    maintainers = [ maintainers.blitz ];
    license = licenses.bsd3;
  };
}
