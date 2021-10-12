{ lib
, stdenv
, fetchFromGitHub
, callPackage

  # Required build tools
, cmake
, makeWrapper
, pkg-config

  # Required dependencies
, fftw
, liblo
, minixml
, zlib

  # Optional dependencies
, alsaSupport ? true
, alsa-lib
, dssiSupport ? false
, dssi
, ladspaH
, jackSupport ? true
, libjack2
, lashSupport ? false
, lash
, ossSupport ? true
, portaudioSupport ? true
, portaudio

  # Optional GUI dependencies
, guiModule ? "off"
, cairo
, fltk13
, libGL
, libjpeg
, libX11
, libXpm
, ntk

  # Test dependencies
, cxxtest
}:

assert builtins.any (g: guiModule == g) [ "fltk" "ntk" "zest" "off" ];

let
  guiName = {
    "fltk" = "FLTK";
    "ntk" = "NTK";
    "zest" = "Zyn-Fusion";
  }.${guiModule};
  mruby-zest = callPackage ./mruby-zest { };
in stdenv.mkDerivation rec {
  pname = "zynaddsubfx";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1vh1gszgjxwn8m32rk5222z1j2cnjax0bqpag7b47v6i36p2q4x8";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/Misc/Config.cpp --replace /usr $out
  '';

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];

  buildInputs = [ fftw liblo minixml zlib ]
    ++ lib.optionals alsaSupport [ alsa-lib ]
    ++ lib.optionals dssiSupport [ dssi ladspaH ]
    ++ lib.optionals jackSupport [ libjack2 ]
    ++ lib.optionals lashSupport [ lash ]
    ++ lib.optionals portaudioSupport [ portaudio ]
    ++ lib.optionals (guiModule == "fltk") [ fltk13 libjpeg libXpm ]
    ++ lib.optionals (guiModule == "ntk") [ ntk cairo libXpm ]
    ++ lib.optionals (guiModule == "zest") [ libGL libX11 ];

  cmakeFlags = [ "-DGuiModule=${guiModule}" ]
    # OSS library is included in glibc.
    # Must explicitly disable if support is not wanted.
    ++ lib.optional (!ossSupport) "-DOssEnable=OFF"
    # Find FLTK without requiring an OpenGL library in buildInputs
    ++ lib.optional (guiModule == "fltk") "-DFLTK_SKIP_OPENGL=ON";

  doCheck = true;
  checkInputs = [ cxxtest ];

  # When building with zest GUI, patch plugins
  # and standalone executable to properly locate zest
  postFixup = lib.optionalString (guiModule == "zest") ''
    patchelf --set-rpath "${mruby-zest}:$(patchelf --print-rpath "$out/lib/lv2/ZynAddSubFX.lv2/ZynAddSubFX_ui.so")" \
      "$out/lib/lv2/ZynAddSubFX.lv2/ZynAddSubFX_ui.so"

    patchelf --set-rpath "${mruby-zest}:$(patchelf --print-rpath "$out/lib/vst/ZynAddSubFX.so")" \
      "$out/lib/vst/ZynAddSubFX.so"

    wrapProgram "$out/bin/zynaddsubfx" \
      --prefix PATH : ${mruby-zest} \
      --prefix LD_LIBRARY_PATH : ${mruby-zest}
  '';

  meta = with lib; {
    description = "High quality software synthesizer (${guiName} GUI)";
    homepage =
      if guiModule == "zest"
      then "https://zynaddsubfx.sourceforge.io/zyn-fusion.html"
      else "https://zynaddsubfx.sourceforge.io";

    license = licenses.gpl2;
    maintainers = with maintainers; [ goibhniu kira-bruneau ];
    platforms = platforms.linux;
  };
}
