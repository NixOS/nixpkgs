{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  libjack2,
  pkg-config,
  which,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "portaudio";
  version = "19.7.0-unstable-2025-07-18";

  src = fetchFromGitHub {
    owner = "PortAudio";
    repo = "portaudio";
    rev = "9abe5fe7db729280080a0bbc1397a528cd3ce658";
    hash = "sha256-SdUqM1ptkVQmEo0JezWNJe5PTtttmOjtO4SV9d3xrVs=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    which
  ];
  buildInputs = [
    libjack2
  ]
  # Enabling alsa causes linux-only sources to be built
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  configureFlags = [
    "--disable-mac-universal"
    "--enable-cxx"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=nullability-inferred-on-nested-type -Wno-error=nullability-completeness-on-arrays -Wno-error=implicit-const-int-float-conversion";

  # Disable parallel build as it fails as:
  #   make: *** No rule to make target '../../../lib/libportaudio.la',
  #     needed by 'libportaudiocpp.la'.  Stop.
  # Next release should address it with
  #     https://github.com/PortAudio/portaudio/commit/28d2781d9216115543aa3f0a0ffb7b4ee0fac551.patch
  enableParallelBuilding = false;

  postPatch = ''
    # workaround for the configure script which expects an absolute path
    export AR=$(which $AR)
  '';

  # not sure why, but all the headers seem to be installed by the make install
  installPhase = ''
    make install
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # fixup .pc file to find alsa library
    sed -i "s|-lasound|-L${alsa-lib.out}/lib -lasound|" "$out/lib/pkgconfig/"*.pc
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp include/pa_mac_core.h $out/include/pa_mac_core.h
  '';

  meta = {
    description = "Portable cross-platform Audio API";
    homepage = "https://www.portaudio.com/";
    # Not exactly a bsd license, but alike
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;
  };

  passthru = {
    api_version = 19;
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };
})
