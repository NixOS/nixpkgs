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
  jackSupport ? true,
  libjack2,
  lashSupport ? false,
  lash,
  ossSupport ? true,
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
  ctestCheckHook,
}:

assert builtins.any (g: guiModule == g) [
  "fltk"
  "ntk"
  "zest"
  "off"
];

let
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
    owner = "zynaddsubfx";
    repo = "zynaddsubfx";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-0siAx141DZx39facXWmKbsi0rHBNpobApTdey07EcXg=";
  };

  outputs = [
    "out"
    "doc"
  ];

  patches = [
    # Lazily expand ZYN_DATADIR to fix builtin banks across updates
    (fetchpatch {
      url = "https://github.com/zynaddsubfx/zynaddsubfx/commit/853aa03f4f92a180b870fa62a04685d12fca55a7.patch";
      hash = "sha256-4BsRZ9keeqKopr6lCQJznaZ3qWuMgD1/mCrdMiskusg=";
    })
  ];

  postPatch = ''
    patchShebangs rtosc/test/test-port-checker.rb src/Tests/check-ports.rb
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    fftw
    liblo
    minixml
    zlib
  ]
  ++ lib.optionals alsaSupport [ alsa-lib ]
  ++ lib.optionals dssiSupport [
    dssi
    ladspaH
  ]
  ++ lib.optionals jackSupport [ libjack2 ]
  ++ lib.optionals lashSupport [ lash ]
  ++ lib.optionals portaudioSupport [ portaudio ]
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
  ++ lib.optionals (guiModule == "zest") [
    libGL
    libX11
  ];

  cmakeFlags = [
    "-DGuiModule=${guiModule}"
    "-DZYN_DATADIR=${placeholder "out"}/share/zynaddsubfx"
  ]
  # OSS library is included in glibc.
  # Must explicitly disable if support is not wanted.
  ++ lib.optional (!ossSupport) "-DOssEnable=OFF"
  # Find FLTK without requiring an OpenGL library in buildInputs
  ++ lib.optional (guiModule == "fltk") "-DFLTK_SKIP_OPENGL=ON";

  CXXFLAGS = [
    # GCC 13: error: 'uint8_t' does not name a type
    "-include cstdint"
  ];

  doCheck = true;
  nativeCheckInputs = [
    cxxtest
    ruby
    ctestCheckHook
  ];

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
  postFixup = lib.optionalString (guiModule == "zest") ''
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
