{
  lib,
  SDL,
  fetchpatch,
  fetchurl,
  fluidsynth,
  libopenmpt-modplug,
  libogg,
  libvorbis,
  pkg-config,
  smpeg,
  stdenv,
  # Boolean flags
  enableNativeMidi ? false,
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
  enableSmpegtest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_mixer";
  version = "1.2.12";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-${finalAttrs.version}.tar.gz";
    hash = "sha256-FkQwgnmpdXmQSeSCavLPx4fK0quxGqFFYuQCUh+GmSo=";
  };

  patches = [
    # Fixes implicit declaration of `Mix_QuitFluidSynth`, which causes build failures with clang.
    # https://github.com/libsdl-org/SDL_mixer/issues/287
    (fetchpatch {
      name = "fluidsynth-fix-implicit-declaration.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/05b12a3c22c0746c29dc5478f5b7fbd8a51a1303.patch";
      hash = "sha256-MDuViLD1w1tAVLoX2yFeJ865v21S2roi0x7Yi7GYRVU=";
    })
    # Backport of 2.0 fixes for incompatible function pointer conversions, fixing builds with clang.
    (fetchpatch {
      name = "fluidsynth-fix-function-pointer-conversions.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/0c504159d212b710a47cb25c669b21730fc78edd.patch";
      hash = "sha256-FSj7JLE2MbGVYCspoq3trXP5Ho+lAtnro2IUOHkto/U";
    })
    # Backport of MikMod fixes, which includes incompatible function pointer conversions.
    (fetchpatch {
      name = "mikmod-fixes.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/a3e5ff8142cf3530cddcb27b58f871f387796ab6.patch";
      hash = "sha256-dqD8hxx6U2HaelUx0WsGPiWuso++LjwasaAeTTGqdbk=";
    })
    # More incompatible function pointer conversion fixes (this time in Vorbis-decoding code).
    (fetchpatch {
      name = "vorbis-fix-function-pointer-conversion.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/9e6d7b67a00656a68ea0c2eace75c587871549b9.patch";
      hash = "sha256-rZI3bFb/KxnduTkA/9CISccKHUgrX22KXg69sl/uXvU=";
    })
    (fetchpatch {
      name = "vorbis-fix-function-pointer-conversion-header-part.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/03bd4ca6aa38c1a382c892cef86296cd621ecc1d.patch";
      hash = "sha256-7HrSHYFYVgpamP7Q9znrFZMZ72jvz5wYpJEPqWev/I4=";
    })
    (fetchpatch {
      name = "vorbis-fix-function-pointer-signature.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/d28cbc34d63dd20b256103c3fe506ecf3d34d379.patch";
      hash = "sha256-sGbtF+Tcjf+6a28nJgawefeeKXnhcwu7G55e94oS9AU=";
    })
  ];

  # Fix location of modplug header
  postPatch = ''
    substituteInPlace music_modplug.h \
      --replace-fail '#include "modplug.h"' '#include <libmodplug/modplug.h>'
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    SDL
    fluidsynth
    libopenmpt-modplug
    libogg
    libvorbis
    smpeg
  ];

  # pass in correct *-config for cross builds
  env.SDL_CONFIG = lib.getExe' SDL.dev "sdl-config";
  env.SMPEG_CONFIG = lib.getExe' smpeg.dev "smpeg-config";

  configureFlags = [
    (lib.enableFeature false "music-ogg-shared")
    (lib.enableFeature false "music-mod-shared")
    (lib.enableFeature true "music-mod-modplug")
    (lib.enableFeature enableNativeMidi "music-native-midi-gpl")
    (lib.enableFeature enableSdltest "sdltest")
    (lib.enableFeature enableSmpegtest "smpegtest")
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  meta = {
    description = "SDL multi-channel audio mixer library";
    homepage = "http://www.libsdl.org/projects/SDL_mixer/";
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    license = lib.licenses.zlib;
    inherit (SDL.meta) platforms;
  };
})
