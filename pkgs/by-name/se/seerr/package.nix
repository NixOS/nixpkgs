{
  lib,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  nodejs-slim_22,
  python3,
  python3Packages,
  sqlite,
  nix-update-script,
  nixosTests,
}:

let
  nodejs-slim = nodejs-slim_22;
  pnpm = pnpm_10.override { inherit nodejs-slim; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "seerr";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "seerr-team";
    repo = "seerr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OF8iX6Q7NK8d3ugGOw7FFcKQul2ERRNqD3SKWtlQuAg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-qSkPC2d3DfM+g/JLf8Jkv0T9Wxnp4m0Sx+wHTyhch34=";
  };

  buildInputs = [ sqlite ];

  nativeBuildInputs = [
    python3
    python3Packages.distutils
    nodejs-slim
    makeWrapper
    pnpmConfigHook
    pnpm
  ];

  preBuild = ''
    export npm_config_nodedir=${nodejs-slim}
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
    makeWrapper '${nodejs-slim}/bin/node' "$out/bin/seerr" \
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
    maintainers = with lib.maintainers; [
      camillemndn
      fallenbagel
    ];
    platforms = lib.platforms.linux;
    mainProgram = "seerr";
  };
})
