{
  lib,
  pnpm_10,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  nodejs_22,
  python3,
  python3Packages,
  sqlite,
  nix-update-script,
  nixosTests,
}:

let
  nodejs = nodejs_22;
  pnpm = pnpm_10.override { inherit nodejs; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "seerr";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "seerr-team";
    repo = "seerr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a3lhQ33Zb+vSu1sQjuqO3bITiQEIOVyFTecmJAhJROU=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-3df72m/ARgfelBLE6Bhi8+ThHytowVOBL2Ndk7auDgg=";
  };

  buildInputs = [ sqlite ];

  nativeBuildInputs = [
    python3
    python3Packages.distutils
    nodejs
    makeWrapper
    pnpm.configHook
  ];

  preBuild = ''
    export npm_config_nodedir=${nodejs}
    pushd node_modules
    pnpm rebuild bcrypt sqlite3
    popd
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build
    CI=true pnpm prune --prod --ignore-scripts
    rm -rf .next/cache

    # Clean up broken symlinks left behind by `pnpm prune`
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r -t $out/share .next node_modules dist public package.json seerr-api.yml
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper '${nodejs}/bin/node' "$out/bin/seerr" \
      --add-flags "$out/share/dist/index.js" \
      --chdir "$out/share" \
      --set NODE_ENV production
  '';

  passthru = {
    inherit (nixosTests) seerr;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open-source media request and discovery manager for Jellyfin, Plex, and Emby";
    homepage = "https://github.com/seerr-team/seerr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.camillemndn ];
    platforms = lib.platforms.linux;
    mainProgram = "seerr";
  };
})
