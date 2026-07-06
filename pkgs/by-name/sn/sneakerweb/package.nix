{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sneakerweb";
  version = "1.0.1-unstable-2026-07-05";

  src = fetchFromCodeberg {
    owner = "worm-blossom";
    repo = "sneakerweb";
    rev = "888cf132207a2bf0622a5633a2d347e9e910538c";
    hash = "sha256-BXF+Iw2eSJPsiVkLrL0RaIqdJtp6yFwU8p9QO6tDDS8=";
  };

  cargoHash = "sha256-6miju3dsKTHlyt+YMJEIP+Ygpm/wQGW4EVCe7iwOi08=";

  meta = {
    description = "";
    homepage = "https://sneakerweb.org/";
    downloadPage = "https://codeberg.org/worm-blossom/sneakerweb";
  };
})
