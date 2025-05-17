{
  config,
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  jackSupport ? true,
  libjack2,
  ossSupport ? stdenv.hostPlatform.isBSD,
  pulseSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
  pkg-config,
  which,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "portaudio";
  version = "19.7.0-unstable-2025-03-24";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "PortAudio";
    repo = "portaudio";
    rev = "27c85c52d70d692c1e7ee017b339891e53a9fffd";
    hash = "sha256-SdUqM1ptkVQmEo0JezWNJe5PTtttmOjtO4SV9d3xrVs=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    pkg-config
    which
  ];

  propagatedBuildInputs =
    lib.optionals alsaSupport [ alsa-lib ]
    ++ lib.optionals jackSupport [ libjack2 ]
    ++ lib.optionals pulseSupport [ libpulseaudio ];

  cmakeFlags = lib.mapAttrsToList (flag: value: lib.cmakeBool flag value) {
    BUILD_SHARED_LIBS = !stdenv.hostPlatform.isStatic;

    PA_USE_ALSA = alsaSupport;
    PA_USE_JACK = jackSupport;
    PA_USE_OSS = ossSupport;
    PA_USE_PULSEAUDIO = pulseSupport;
  };

  postPatch = ''
    # remove prefix from library and include paths
    sed -E -i \
      -e 's/^(libdir=).*/\1@CMAKE_INSTALL_FULL_LIBDIR@/' \
      -e 's/^(includedir=).*/\1@CMAKE_INSTALL_FULL_INCLUDEDIR@/' \
      cmake/portaudio-2.0.pc.in
  '';

  meta = {
    description = "Portable cross-platform Audio API";
    homepage = "https://www.portaudio.com/";
    changelog = "https://github.com/PortAudio/portaudio/releases";
    # Not exactly a bsd license, but alike
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;

    pkgConfigModules = [ "portaudio-2.0" ];
  };

  passthru = {
    api_version = 19;
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };
})
