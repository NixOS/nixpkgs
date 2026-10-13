{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  onnxruntime,
  alsa-lib,
}:

# The model graph (export/gdi2m.onnx and its sidecars) is produced separately
# by export/export_onnx.py and is not part of the source, so this installs the
# inference tool alone; pass the graph at run time with --model or $GDI2M_MODEL.
stdenv.mkDerivation (finalAttrs: {
  pname = "gdi2m";
  version = "0.1.0-unstable-2026-10-13";

  __structuredAttrs = true;
  strictDeps = true;

  # A fork of maximmashkov1/gdi2m carrying the Linux port (tools/gdi2m/
  # platform.h, audio_io.h, alsa_capture.h, alsa_out.h, alsa_midi.h and the
  # CMakeLists !WIN32 branch). Drop back to upstream once it is merged there.
  src = fetchFromGitHub {
    owner = "hatch01";
    repo = "gdi2m";
    rev = "a7bd8d8b055224bcbf976797a35af9ad1671e312";
    hash = "sha256-lgxBTlBh02oYg9teWzDwWM32mTqHLN2UdXdIWwc0ymg=";
  };

  # The console tool's CMakeLists.txt sits beside its sources one level down;
  # fetchFromGitHub unpacks to `source`.
  sourceRoot = "${finalAttrs.src.name}/tools/gdi2m";

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    onnxruntime
    alsa-lib
  ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = {
    description = "Real-time guitar DI to MIDI (console inference tool)";
    longDescription = ''
      gdi2m transcribes a guitar DI signal to MIDI note events in real time
      using a causal CNN+GRU model exported to ONNX. This builds the command-line
      inference tool (bench / file / live / selftest) against the system ONNX
      Runtime and ALSA. The Windows-only Direct2D panel is not built; the model
      graph is supplied at run time.
    '';
    homepage = "https://github.com/maximmashkov1/gdi2m";
    license = lib.licenses.mit;
    mainProgram = "gdi2m";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
