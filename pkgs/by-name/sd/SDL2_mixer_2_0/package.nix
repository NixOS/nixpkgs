# SDL2_mixer_2_0 pinned for lzwolf
{
  SDL2_mixer,
  fetchFromGitHub,
  fetchpatch,
  lzwolf,
  timidity,
}:

let
  attrset = {
    version = "2.0.4";

    src = fetchFromGitHub {
      owner = "libsdl-org";
      repo = "SDL_mixer";
      rev = "release-${attrset.version}";
      hash = "sha256-vo9twUGeK2emDiGd9kSGuA/X8TxVmQrRFFm71zawWYM=";
    };

    patches = [
      # These patches fix incompatible function pointer conversion errors with clang 16.
      (fetchpatch {
        url = "https://github.com/libsdl-org/SDL_mixer/commit/4119ec3fe838d38d2433f4432cd18926bda5d093.patch";
        stripLen = 2;
        hash = "sha256-Ug1EEZIRcV8+e1MeMsGHuTW7Zn6j4szqujP8IkIq2VM=";
      })
      # Based on https://github.com/libsdl-org/SDL_mixer/commit/64ab759111ddb1b033bcce64e1a04e0cba6e498f
      ./SDL_mixer-2.0-incompatible-pointer-comparison-fix.patch
    ];

    # fix default path to timidity.cfg so MIDI files could be played
    postPatch = ''
      substituteInPlace timidity/options.h \
        --replace "/usr/share/timidity" "${timidity}/share/timidity"
    '';

    passthru.tests.lzwolf = lzwolf;
  };
in
SDL2_mixer.overrideAttrs (_: attrset)
