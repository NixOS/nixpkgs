{
  lib,
  pnpm_9,
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
  pnpm = pnpm_9.override { inherit nodejs; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jellyseerr";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "Fallenbagel";
    repo = "jellyseerr";
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
    cp -r -t $out/share .next node_modules dist public package.json jellyseerr-api.yml
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper '${nodejs}/bin/node' "$out/bin/jellyseerr" \
      --add-flags "$out/share/dist/index.js" \
      --chdir "$out/share" \
      --set NODE_ENV production
  '';

  passthru = {
    inherit (nixosTests) jellyseerr;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fork of overseerr for jellyfin support";
    homepage = "https://github.com/Fallenbagel/jellyseerr";
    longDescription = ''
      Jellyseerr is a free and open source software application for managing
      requests for your media library. It is a a fork of Overseerr built to
      bring support for Jellyfin & Emby media servers!
    '';
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.camillemndn ];
    platforms = lib.platforms.linux;
    mainProgram = "jellyseerr";
  };
})
