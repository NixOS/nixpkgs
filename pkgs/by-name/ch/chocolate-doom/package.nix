{
  lib,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  autoreconfHook,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  python3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chocolate-doom";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "chocolate-doom";
    repo = "chocolate-doom";
    rev = "chocolate-doom-${finalAttrs.version}";
    hash = "sha256-VxbhaRMzj9oFakuH8mw36IPgBctYPajURrawRBrEjP4=";
  };

  patches = [
    # Pull upstream patch to fix builx against gcc-10:
    #   https://github.com/chocolate-doom/chocolate-doom/pull/1257
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/chocolate-doom/chocolate-doom/commit/a8fd4b1f563d24d4296c3e8225c8404e2724d4c2.patch";
      hash = "sha256-EvYIswWqOxCPzPQE+vzjz9cbwtMKXIyRLV6Lkuzzq7Y=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_net
  ];

  outputs = [ "out" "man" ];

  enableParallelBuilding = true;

  strictDeps = true;

  postPatch = ''
    sed -i -e 's#/games#/bin#g' src{,/setup}/Makefile.am
    patchShebangs --build man/{simplecpp,docgen}
  '';

  meta = {
    homepage = "http://chocolate-doom.org/";
    description = "A Doom source port that accurately reproduces the experience of Doom as it was played in the 1990s";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    hydraPlatforms = lib.platforms.linux; # darwin times out
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
})
