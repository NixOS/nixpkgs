{
  config,
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libusb1,
  pkg-config,
  libGLU,
  libGL,
  libjpeg_turbo,
  libva,
  glfw3,
  opencl-headers,
  ocl-icd,
  enableCuda ? config.cudaSupport,
  cudaPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freenect2";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "SandDream";
    repo = "libfreenect2";
    rev = "c4e4274903699af86c7dcb9007963553811cecdc";
    sha256 = "sha256-VnebcVVpt02JIwG9cIn19OV8Z4r/WpVSnba55uqINCY=";
  };

  buildInputs = [
    pkg-config
    libusb1
    glfw3
    libjpeg_turbo
    libGL
    libGLU
    opencl-headers
    ocl-icd
    libva
  ]
  ++ lib.optionals enableCuda (
    with cudaPackages;
    [
      cuda_nvcc
      cuda_cudart
    ]
  );

  nativeBuildInputs = [
    cmake
    libusb1
    pkg-config
  ]
  ++ lib.optionals enableCuda (cudaPackages.cuda_nvcc);

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    (lib.cmakeBool "CMAKE_BUILD_WITH_INSTALL_RPATH" false)
    (lib.cmakeBool "CMAKE_INSTALL_RPATH_USE_LINK_PATH" true)
    (lib.cmakeFeature "OpenGL_GL_PREFERENCE" "LEGACY")

    (lib.cmakeBool "BUILD_EXAMPLES" true)
    (lib.cmakeBool "ENABLE_CUDA" enableCuda)
  ];

  postInstall = ''
    install -D bin/Protonect $out/bin/Protonect

    mkdir -p $out/lib/udev/rules.d
    cp ../platform/linux/udev/90-kinect2.rules $out/lib/udev/rules.d/90-kinect2.rules
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Drivers and libraries for the Xbox Kinect device on Windows, Linux, and macOS";
    homepage = "http://openkinect.org";
    license = with lib.licenses; [
      gpl2
      asl20
    ];
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
