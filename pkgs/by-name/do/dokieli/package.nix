{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  xsel,
  yarn-berry_4,
  unstableGitUpdater,
  nodePackages,
}:

let
  yarn-berry = yarn-berry_4;
  serve = nodePackages.serve;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "dokieli";
  version = "0-unstable-2025-04-28";

  src = fetchFromGitHub {
    owner = "linkeddata";
    repo = "dokieli";
    rev = "eda3da244e7224ef3819be47e9bf101aceee2701";
    hash = "sha256-jB3xomCeKfU/Dbl5s2QPLwkUiifKWRcQhgokoFwB7Ws=";
  };

  passthru.updateScript = unstableGitUpdater { };

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    hash = "sha256-ROGLDrLrvFRbnIDSrrklMYUa1TCf/cfgucQzG7FnSBc=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r * $out
    runHook postInstall
  '';

  nativeBuildInputs = [
    makeWrapper
    yarn-berry.yarnBerryConfigHook
    # Needed for executing package.json scripts
    nodejs
  ];

  postFixup = ''
    makeWrapper ${nodejs}/bin/npx $out/bin/dokieli           \
      --prefix PATH : ${
        lib.makeBinPath ([
          nodejs
          xsel
          serve
        ])
      }   \
      --add-flags serve                                      \
      --chdir $out
  '';

  doDist = false;

  meta = {
    description = "dokieli is a clientside editor for decentralised article publishing, annotations and social interactions";
    homepage = "https://github.com/linkeddata/dokieli";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
    teams = [ lib.teams.ngi ];
    mainProgram = "dokieli";
  };
})
