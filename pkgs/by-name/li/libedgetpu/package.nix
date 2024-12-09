{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
  abseil-cpp,
  flatbuffers,
  fetchpatch,
  xxd,
}:
let
  # Tensorflow 2.16.1 requires Flatbuffers 23.5.26
  # Compile as a shared library
  flatbuffers_23_5_26 = flatbuffers.overrideAttrs (oldAttrs: rec {
    version = "23.5.26";
    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [ "-DFLATBUFFERS_BUILD_SHAREDLIB=ON" ];
    NIX_CXXSTDLIB_COMPILE = "-std=c++17";
    configureFlags = (oldAttrs.configureFlags or [ ]) ++ [ "--enable-shared" ];
    src = fetchFromGitHub {
      owner = "google";
      repo = "flatbuffers";
      rev = "v${version}";
      hash = "sha256-e+dNPNbCHYDXUS/W+hMqf/37fhVgEGzId6rhP3cToTE=";
    };
  });
in
stdenv.mkDerivation {
  pname = "libedgetpu";
  version = "0-unstable-2024-03-14";

  src = fetchFromGitHub {
    owner = "google-coral";
    repo = "libedgetpu";
    rev = "e35aed18fea2e2d25d98352e5a5bd357c170bd4d";
    hash = "sha256-SabiFG/EgspiCFpg8XQs6RjFhrPPUfhILPmYQQA1E2w=";
  };

  patches = [
    (fetchpatch {
      name = "fix-makefile-to-compile-with-latest-tensorflow.patch";
      url = "https://patch-diff.githubusercontent.com/raw/google-coral/libedgetpu/pull/66.patch";
      hash = "sha256-mMODpQmikfXtsQvtgh26cy97EiykYNLngSjidOBt/3I=";
    })
  ];

  postPatch = ''
    # Use dedicated group for coral devices
    substituteInPlace debian/edgetpu-accelerator.rules \
      --replace-fail "plugdev" "coral"
  '';

  makeFlags = [
    "-f"
    "makefile_build/Makefile"
    "libedgetpu"
  ];

  buildInputs = [
    abseil-cpp
    libusb1
    flatbuffers_23_5_26
  ];

  nativeBuildInputs = [ xxd ];

  NIX_CXXSTDLIB_COMPILE = "-std=c++17";

  TFROOT = fetchFromGitHub {
    owner = "tensorflow";
    repo = "tensorflow";
    rev = "v2.16.1";
    hash = "sha256-UPvK5Kc/FNVJq3FchN5IIBBObvcHtAPVv0ARzWzA35M=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 out/direct/k8/libedgetpu.so.1.0 -t $out/lib
    ln -s $out/lib/libedgetpu.so.1.0 $out/lib/libedgetpu.so.1
    install -Dm444 debian/edgetpu-accelerator.rules $out/lib/udev/rules.d/99-edgetpu-accelerator.rules
    install -Dm444 tflite/public/*.h -t $out/include
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/google-coral/libedgetpu";
    description = "Userspace level runtime driver for Coral devices";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ frenetic00 ];
    platforms = lib.platforms.linux;
  };
}
