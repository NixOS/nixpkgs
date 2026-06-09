{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  meson,
  ninja,
  pkg-config,
  gettext,
  canfigger,
  pcg_c,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  protobufc,
  libsodium,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dealers-choice";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "Dealer-s-Choice";
    repo = "dealers-choice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2x/nm6NTnQ6tVbQPJOJs+GIwa4Xh2n/e3Kwu0PaBy/Y=";
    fetchSubmodules = false;
  };

  postPatch = ''
    substituteInPlace src/graphics.h \
      --replace-fail '#include <SDL_image.h>' '#include <SDL2/SDL_image.h>'
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    canfigger
    pcg_c
    SDL2
    SDL2_ttf
    SDL2_image
    protobufc
    libsodium
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gettext;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Online Multiplayer Stud and Draw Poker, Texas Hold'em and Omaha";
    homepage = "https://dealer-s-choice.github.io/";
    changelog = "https://github.com/Dealer-s-Choice/dealers-choice/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andy5995 ];
    platforms = lib.platforms.all;
    mainProgram = "dealers-choice";
  };
})
