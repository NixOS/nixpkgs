{
  lib,
  pnpm_9,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  nodejs_22,
  python3,
  sqlite,
  nix-update-script,
}:

let
  nodejs = nodejs_22;
  pnpm = pnpm_9.override { inherit nodejs; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jellyseerr";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "Fallenbagel";
    repo = "jellyseerr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vAMuiHcf13CDyOB0k36DXUk+i6K6h/R7dmBLJsMkzNA=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-iSzs+lMQzcFjUz4K3rYP0I6g/wVz6u49FSQuPHXbVRM=";
  };

  buildInputs = [ sqlite ];

  nativeBuildInputs = [
    python3
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
    pnpm prune --prod --ignore-scripts
    rm -rf .next/cache
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r -t $out/share .next node_modules dist public package.json overseerr-api.yml
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper '${nodejs}/bin/node' "$out/bin/jellyseerr" \
      --add-flags "$out/share/dist/index.js" \
      --chdir "$out/share" \
      --set NODE_ENV production
  '';

  passthru.updateScript = nix-update-script { };

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
