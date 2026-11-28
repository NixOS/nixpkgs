{
  lib,
  stdenv,
  fetchFromGitea,
  fetchYarnDeps,
  writableTmpDirAsHomeHook,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  jpegoptim,
  oxipng,
  svgo,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "akkoma-fe";
  version = "3.20.0";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "akkoma-fe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DQPFdpzFBlYa3yap8Dimqkq6a8FjwIJvOHe3TTwFFIU=";

    # upstream repository archive fetching is broken
    forceFetchGit = true;
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-oGmO2AVa6tGYIvs3K7bJ+5db6NxTjO1ZR40aZ/yJQ2M=";
  };

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    yarnConfigHook
    yarnBuildHook
    nodejs
    jpegoptim
    oxipng
    svgo
  ];

  postPatch = ''
    # Build scripts assume to be used within a Git repository checkout
    sed -E -i '/^let commitHash =/,/;$/clet commitHash = "${finalAttrs.src.rev}";' \
      build/webpack.prod.conf.js
  '';

  installPhase = ''
    runHook preInstall

    # (Losslessly) optimise compression of image artifacts
    find dist -type f -name '*.jpg' -execdir ${jpegoptim}/bin/jpegoptim -w$NIX_BUILD_CORES {} \;
    find dist -type f -name '*.png' -execdir ${oxipng}/bin/oxipng -o max -t $NIX_BUILD_CORES {} \;
    find dist -type f -name '*.svg' -execdir ${svgo}/bin/svgo {} \;

    cp -R -v dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=stable" ];
  };

  meta = {
    description = "Frontend for Akkoma";
    homepage = "https://akkoma.dev/AkkomaGang/akkoma-fe/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yuka ];
  };
})
