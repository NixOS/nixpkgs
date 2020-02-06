{ stdenv, fetchFromGitHub, writeText, makeWrapper
# Dependencies documented @ https://gnuradio.org/doc/doxygen/build_guide.html
# => core dependencies
, cmake, pkgconfig, git, boost, cppunit, fftw
# => python wrappers
, python3, python3Packages, swig3, numpy, scipy, matplotlib,
pyopengl,
pyaml, sphinx, lxml, pygobject3, pycairo, gtk3, gobjectIntrospection
# => grc - the gnu radio companion
, Mako, pygtk
# => gr-wavelet: collection of wavelet blocks
, gsl
# => gr-qtgui: the Qt-based GUI
, qt5, qwt, qwt6, pyqt5
# => gr-audio: audio subsystems (system/OS dependent)
, alsaLib   # linux   'audio-alsa'
, CoreAudio # darwin  'audio-osx'
# => uhd: the Ettus USRP Hardware Driver Interface
, uhd
# => gr-video-sdl: PAL and NTSC display
, SDL
# Other
, libusb1, orc, cppzmq, zeromq, doxygen, wrapGAppsHook, pango, cairo, log4cpp
, wrapQtAppsHook
, ccache
}:

stdenv.mkDerivation rec {
  name = "gnuradio-${version}";
  version = "3.8.0.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "gnuradio";
    rev = "4cc4c74c10411235fb36de58be09022c5573dbd8";
    sha256 = "30ec08d49a6aaa412e6edc005a5645d1cc8ae9e10f45d88946f1424817f53128";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake pkgconfig git makeWrapper cppunit orc
    wrapQtAppsHook
  ];

  makeWrapperArgs = [
    # Firstly, add all necessary QT variables
    "\${qtWrapperArgs[@]}"

    # Then, add the installed scripts/ directory to the python path
    "--prefix" "PYTHONPATH" ":" "$out/lib/${python3Packages.python.libPrefix}/site-packages"

    # Finally, move to directory that contains data
    "--run" "\"cd $out/share/${name}\""
  ];

  buildInputs = [
      cppzmq zeromq
      doxygen
      wrapGAppsHook
      gtk3
      gobjectIntrospection
      ccache
      boost fftw swig3 qt5.qtbase
      pango.out
      cairo
      qwt SDL libusb1 uhd gsl log4cpp
    ] ++ stdenv.lib.optionals stdenv.isLinux  [ alsaLib   ]
      ++ stdenv.lib.optionals stdenv.isDarwin [ CoreAudio ];

  propagatedBuildInputs = with python3Packages; [
        Mako numpy scipy matplotlib pyqt5 pyopengl
        pyaml
        sphinx
        lxml
        pygobject3
        pycairo
        gtk3
        gobjectIntrospection
        qwt
        (python3.withPackages (ps : with ps; [pygobject3]))
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace \
        gr-fec/include/gnuradio/fec/polar_decoder_common.h \
        --replace BOOST_CONSTEXPR_OR_CONST const
  '';

  # Enables composition with nix-shell
  grcSetupHook = writeText "grcSetupHook.sh" ''
    addGRCBlocksPath() {
      addToSearchPath GRC_BLOCKS_PATH $1/share/gnuradio/grc/blocks
    }
    addEnvHooks "$targetOffset" addGRCBlocksPath
  '';

  setupHook = [ grcSetupHook ];

  # patch wxgui and pygtk check due to python importerror in a headless environment
  # wxgtk gui will be removed in GR3.8
  # c++11 hack may not be necessary anymore
  preConfigure = ''
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-unused-variable ${stdenv.lib.optionalString (!stdenv.isDarwin) "-std=c++11"}"
      sed -i 's/.*pygtk_version.*/set(PYGTK_FOUND TRUE)/g' grc/CMakeLists.txt
      find . -name "CMakeLists.txt" -exec sed -i '1iadd_compile_options($<$<COMPILE_LANGUAGE:CXX>:-std=c++11>)' "{}" ";"
    '';

  # Framework path needed for qwt6_qt4 but not qwt5
  cmakeFlags =
    ["-DQWT_LIBRARIES=${qwt}/lib/libqwt.so"] ++
    (stdenv.lib.optionals stdenv.isDarwin [ "-DCMAKE_FRAMEWORK_PATH=${qwt}/lib" ]);

  # - Ensure we get an interactive backend for matplotlib. If not the gr_plot_*
  #   programs will not display anything. Yes, $MATPLOTLIBRC must point to the
  #   *dirname* where matplotlibrc is located, not the file itself.
  # - GNU Radio core is C++ but the user interface (GUI and API) is Python, so
  #   we must wrap the stuff in bin/.
  # Notes:
  # - May want to use makeWrapper instead of wrapProgram
  # - may want to change interpreter path on Python examples instead of wrapping
  # - see https://github.com/NixOS/nixpkgs/issues/22688 regarding use of --prefix / python.withPackages
  # - see https://github.com/NixOS/nixpkgs/issues/24693 regarding use of DYLD_FRAMEWORK_PATH on Darwin
  # - The tech preview places python libraries into dist-packages, upstream has an issue to fix this for the proper release.
  postFixup = ''
      printf "backend : Qt5Agg\n" > "$out/share/gnuradio/matplotlibrc"
      for file in $(find $out/bin $out/share/gnuradio/examples -type f -executable); do
          wrapProgram "$file" \
              --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out"):$(toPythonPath "$out")/../dist-packages \
              --set MATPLOTLIBRC "$out/share/gnuradio" \
              ${stdenv.lib.optionalString stdenv.isDarwin "--set DYLD_FRAMEWORK_PATH /System/Library/Frameworks"}
      done
    '';

  meta = with stdenv.lib; {
    description = "Software Defined Radio (SDR) software";
    longDescription = ''
      GNU Radio is a free & open-source software development toolkit that
      provides signal processing blocks to implement software radios. It can be
      used with readily-available low-cost external RF hardware to create
      software-defined radios, or without hardware in a simulation-like
      environment. It is widely used in hobbyist, academic and commercial
      environments to support both wireless communications research and
      real-world radio systems.
    '';
    homepage = https://www.gnuradio.org;
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor fpletz tomberek ];
  };
}
