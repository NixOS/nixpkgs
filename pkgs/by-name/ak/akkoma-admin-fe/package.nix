{
  lib,
  stdenv,
  fetchFromGitea,
  writableTmpDirAsHomeHook,
  yarn-berry_3,
  nodejs,
  git,
  python3,
  pkg-config,
  libsass,
  nix-update-script,
  xcbuild,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "admin-fe";
  version = "2.3.0-2-unstable-2025-12-18";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "admin-fe";
    rev = "a0e3b95a75367d1b5e329963a3d54f67cf59dfca";
    hash = "sha256-eEAM1itUvpR57B0BseeeRuV+ZjcYiJvbdln8vleRNcc=";
    # archive export endpoint on akkoma.dev 500s
    forceFetchGit = true;
  };

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-YZlvIr27bHBgsQcBiayqEX07kjX6iH2Kh5wt+PQFq04=";
  };

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    yarn-berry_3
    yarn-berry_3.yarnBerryConfigHook
    nodejs
    pkg-config
    python3
    git
    libsass
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin xcbuild;

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
    homepage = "https://akkoma.dev/AkkomaGang/admin-fe/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mvs ];
  };
})
