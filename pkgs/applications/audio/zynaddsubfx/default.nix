{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  fetchpatch,

  # Required build tools
  cmake,
  makeWrapper,
  pkg-config,

  # Required dependencies
  fftw,
  liblo,
  minixml,
  zlib,

  # Optional dependencies
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  dssiSupport ? false,
  dssi,
  ladspaH,
  jackSupport ? (!stdenv.hostPlatform.isWindows),
  libjack2,
  lashSupport ? false,
  lash,
  ossSupport ? (!stdenv.hostPlatform.isWindows),
  portaudioSupport ? true,
  portaudio,
  sndioSupport ? stdenv.hostPlatform.isOpenBSD,
  sndio,

  # Optional GUI dependencies
  guiModule ? "off",
  cairo,
  fltk,
  libGL,
  libjpeg,
  libX11,
  libXpm,
  ntk,

  # Test dependencies
  cxxtest,
  ruby,
  windows,
  makeStaticLibraries,
}:

assert builtins.any (g: guiModule == g) [
  "fltk"
  "ntk"
  "zest"
  "off"
];

let
  makeStatic = p: p.override { isStatic = stdenv.hostPlatform.isWindows; };
  guiName =
    {
      "fltk" = "FLTK";
      "ntk" = "NTK";
      "zest" = "Zyn-Fusion";
    }
    .${guiModule};

  mruby-zest = callPackage ./mruby-zest { };
in
stdenv.mkDerivation rec {
  pname = "zynaddsubfx";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-0siAx141DZx39facXWmKbsi0rHBNpobApTdey07EcXg=";
  };

  outputs = [
    "out"
  ]
    # mkDerivation bug? avoids: Not linking DLLs in the non-existent folder for doc
  ++ lib.optional (!stdenv.hostPlatform.isWindows) "doc";

  patches = [
    # Lazily expand ZYN_DATADIR to fix builtin banks across updates
    (fetchpatch {
      url = "https://github.com/zynaddsubfx/zynaddsubfx/commit/853aa03f4f92a180b870fa62a04685d12fca55a7.patch";
      hash = "sha256-4BsRZ9keeqKopr6lCQJznaZ3qWuMgD1/mCrdMiskusg=";
    })
#    (./0001-Statically-link-core-gcc-libraries.patch)
  ];

  postPatch = ''
    patchShebangs rtosc/test/test-port-checker.rb src/Tests/check-ports.rb
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optional (!stdenv.hostPlatform.isWindows) makeWrapper;

  buildInputs =
    [
      (makeStatic fftw)
      (makeStatic liblo)
      (makeStatic minixml)
      (zlib.override { static = stdenv.hostPlatform.isWindows;
                       shared = (!stdenv.hostPlatform.isWindows); })
    ]
    ++ lib.optionals alsaSupport [ alsa-lib ]
    ++ lib.optionals dssiSupport [
      dssi
      ladspaH
    ]
    ++ lib.optionals jackSupport [ libjack2 ]
    ++ lib.optionals lashSupport [ lash ]
    ++ lib.optionals portaudioSupport [ (portaudio) ]
    ++ lib.optionals sndioSupport [ sndio ]
    ++ lib.optionals (guiModule == "fltk") [
      fltk
      libjpeg
      libXpm
    ]
    ++ lib.optionals (guiModule == "ntk") [
      ntk
      cairo
      libXpm
    ]
    ++ lib.optionals (guiModule == "zest" && (!stdenv.hostPlatform.isWindows)) [
      libGL
      libX11
    ]
    ++ lib.optionals (stdenv.hostPlatform.isMinGW) [ windows.mingw_w64_pthreads ];

  cmakeFlags =
    [
      "-DGuiModule=${guiModule}"
      "-DZYN_DATADIR=${placeholder "out"}/share/zynaddsubfx"
    ]
    # OSS library is included in glibc.
    # Must explicitly disable if support is not wanted.
    ++ lib.optional (!ossSupport) "-DOssEnable=OFF"
    # Find FLTK without requiring an OpenGL library in buildInputs
    ++ lib.optional (guiModule == "fltk") "-DFLTK_SKIP_OPENGL=ON"
    ++ lib.optional portaudioSupport "-DDefaultOutput=pa"

    ++ lib.optionals stdenv.hostPlatform.isMinGW [
#    "-DCMAKE_TOOLCHAIN_FILE=${./mingw.cmake}"
      #(lib.cmakeFeature "CMAKE_C_FLAGS" "-static-libstdc++")
      #(lib.cmakeFeature "CMAKE_CXX_FLAGS" "-static-libstdc++")
 ];

  CXXFLAGS = [
    # GCC 13: error: 'uint8_t' does not name a type
    "-include cstdint"
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    "-static" "-static-libgcc" "-static-libstdc++"
  ];

  NIX_CFLAGS_LINK = [
    "-static-libstdc++"
    "-Wl,-Bstatic -lmcfgthread"
  ];

  doCheck = true;
  nativeCheckInputs = [
    cxxtest
    ruby
  ];

  # TODO: Update cmake hook to make it simpler to selectively disable cmake tests: #113829
  checkPhase =
    let
      disabledTests =
        # PortChecker is non-deterministic. It's fixed in the master
        # branch, but backporting would require an update to rtosc, so
        # we'll just disable it until the next release.
        [ "PortChecker" ]

        # Tests fail on aarch64
        ++ lib.optionals stdenv.hostPlatform.isAarch64 [
          "MessageTest"
          "UnisonTest"
        ];
    in
    ''
      runHook preCheck
      ctest --output-on-failure -E '^${lib.concatStringsSep "|" disabledTests}$'
      runHook postCheck
    '';

  installPhase = lib.optionalString (stdenv.hostPlatform.isWindows) ''
  mkdir -p $out/bin

  cp src/zynaddsubfx.exe $out/bin
  cp src/Plugin/ZynAddSubFX/vst/ZynAddSubFX.dll $out/bin

  cp -r ../instruments/banks $out/bin

	mkdir -p $out/bin/qml
	touch $out/bin/qml/MainWindow.qml

	ln -s ${mruby-zest}/bin/{font,schema} $out/bin
	ln -s ${mruby-zest}/bin/zest.exe $out/bin/zyn-fusion.exe
	ln -s ${mruby-zest}/bin/libzest.dll $out/bin
  '';

  # Use Zyn-Fusion logo for zest build
  # An SVG version of the logo isn't hosted anywhere we can fetch, I
  # had to manually derive it from the code that draws it in-app:
  # https://github.com/mruby-zest/mruby-zest-build/blob/3.0.6/src/mruby-zest/example/ZynLogo.qml#L65-L97
  postInstall = lib.optionalString (guiModule == "zest") ''
    rm -r "$out/share/pixmaps"
    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    cp ${./ZynLogo.svg} "$out/share/icons/hicolor/scalable/apps/zynaddsubfx.svg"
  '';

  # When building with zest GUI, patch plugins
  # and standalone executable to properly locate zest
  postFixup = lib.optionalString (guiModule == "zest" && (!stdenv.hostPlatform.isWindows)) ''
    for lib in "$out/lib/lv2/ZynAddSubFX.lv2/ZynAddSubFX_ui.so" "$out/lib/vst/ZynAddSubFX.so"; do
      patchelf --set-rpath "${mruby-zest}:$(patchelf --print-rpath "$lib")" "$lib"
    done

    wrapProgram "$out/bin/zynaddsubfx" \
      --prefix PATH : ${mruby-zest} \
      --prefix LD_LIBRARY_PATH : ${mruby-zest}
  '';

  meta = with lib; {
    description = "High quality software synthesizer (${guiName} GUI)";
    mainProgram = "zynaddsubfx";
    homepage =
      if guiModule == "zest" then
        "https://zynaddsubfx.sourceforge.io/zyn-fusion.html"
      else
        "https://zynaddsubfx.sourceforge.io";

    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.all;

    # On macOS:
    # - Tests don't compile (ld: unknown option: --no-as-needed)
    # - ZynAddSubFX LV2 & VST plugin fail to compile (not setup to use ObjC version of pugl)
    # - TTL generation crashes (`pointer being freed was not allocated`) for all VST plugins using AbstractFX
    # - Zest UI fails to start on pulg_setup: Could not open display, aborting.
    broken = stdenv.hostPlatform.isDarwin;
  };
}
