{
  config,
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  alsa-lib,
  libjack2,
  pulseSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
  pkg-config,
  which,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "portaudio";
  version = "19.7.0-unstable-2026-02-19";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "PortAudio";
    repo = "portaudio";
    rev = "5dcff94e28a63aed67b404af9eef9ef8423ab9e9";
    hash = "sha256-jHYFLNnDUWtls3pj92dTXieZCG7cBVy6dgdPzXT49wI=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    pkg-config
    which
  ];

  propagatedBuildInputs =
    [
      libjack2
    ]
    ++ lib.optionals pulseSupport [ libpulseaudio ]
    # Enabling alsa causes linux-only sources to be built
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  cmakeFlags = lib.mapAttrsToList (flag: value: lib.cmakeBool flag value) {
    BUILD_SHARED_LIBS = !stdenv.hostPlatform.isStatic;
    PA_USE_PULSEAUDIO = pulseSupport;
  };

  postPatch = ''
    # remove prefix from library and include paths
    substituteInPlace cmake/portaudio-2.0.pc.in \
      --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' \
                     'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' \
                     'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  meta = {
    description = "Portable cross-platform Audio API";
    homepage = "https://www.portaudio.com/";
    # Not exactly a bsd license, but alike
    license = lib.licenses.mit;
    maintainers = [ ];
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
