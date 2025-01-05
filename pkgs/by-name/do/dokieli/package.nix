{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  nodejs,
  xsel,
}:

mkYarnPackage rec {
  pname = "dokieli";
  version = "0-unstable-2024-09-23";

  src = fetchFromGitHub {
    owner = "linkeddata";
    repo = "dokieli";
    rev = "40ebbc60ba48d8b08f763b07befba96382c5f027";
    hash = "sha256-lc96jOR8uXLcZFhN3wpSd9O5cUdKxllB8WWCh2oWuEw=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-TEXCCLFhpwHZJ8zRGsC7J6EwNaFpIi+CZ3L5uilebK4=";
  };

  packageJSON = ./package.json;

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out
  '';

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    makeWrapper ${nodejs}/bin/npx $out/bin/dokieli           \
      --prefix PATH : ${
        lib.makeBinPath ([
          nodejs
          xsel
        ])
      }   \
      --add-flags serve                                      \
      --chdir $out/deps/dokieli
  '';

  doDist = false;

  meta = {
    description = "dokieli is a clientside editor for decentralised article publishing, annotations and social interactions";
    homepage = "https://github.com/linkeddata/dokieli";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
    mainProgram = "dokieli";
  };
}
