{
  lib,
  stdenv,
  fetchFromGitea,
  cctools,
  yarn-berry_3,
  nodejs,
  pkg-config,
  xcbuild,
  nix-update-script,
}:

let
  yarn-berry = yarn-berry_3;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "admin-fe";
  version = "2.3.0-2-unstable-2025-12-07";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "admin-fe";
    rev = "a0e3b95a75367d1b5e329963a3d54f67cf59dfca";
    hash = "sha256-eEAM1itUvpR57B0BseeeRuV+ZjcYiJvbdln8vleRNcc=";

    # upstream repository archive fetching is broken
    forceFetchGit = true;
  };

  patches = [
    ./0001-Use-sass-instead-of-deprecated-node-sass.patch
    ./0002-Fix-use-of-deprecated-deep.patch
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes patches;
    hash = "sha256-XfRUAlqPp6m0HXeBWPmKZNxVUVKvIRNjDqzBbKWz2Ms=";
  };

  nativeBuildInputs = [
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    nodejs
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    cctools.libtool
  ];

  buildPhase = ''
    runHook preBuild
    yarn run build:prod --offline
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -R -v dist $out
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=stable" ];
  };

  meta = {
    description = "Admin interface for Akkoma";
    homepage = "https://akkoma.dev/AkkomaGang/akkoma-fe/";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
})
