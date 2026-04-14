{
  lib,
  stdenv,
  fetchurl,
  testers,
  meson,
  ninja,
  pkg-config,
  gettext,
  canfigger,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  SDL2_net,
  protobufc,
  libsodium,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dealers-choice";
  version = "0.0.13";

  src = fetchurl {
    url = "https://github.com/Dealer-s-Choice/${finalAttrs.pname}/releases/download/v${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    hash = "sha256-rZ+Sfu558CZPs9maJY3A43e6QVB9Z5BmEQ44i+jf2Ng=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    canfigger
    SDL2
    SDL2_ttf
    SDL2_image
    SDL2_net
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
    changelog = "https://github.com/Dealer-s-Choice/${finalAttrs.pname}/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = finalAttrs.pname;
  };
})
