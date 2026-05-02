{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smfh";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "smfh";
    tag = finalAttrs.version;
    hash = "sha256-RgszLC/p9uov6aXnPGbFRkPzT5xleX17wBCdoMT1wcA=";
  };

  cargoHash = "sha256-7IcoDgRvpye2lm+bdPlVKj0GO6QBABiQKVwSxL4Mh5k=";

  meta = {
    description = "Sleek Manifest File Handler";
    homepage = "https://github.com/feel-co/smfh";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.feel-co ];
    mainProgram = "smfh";
  };
})
