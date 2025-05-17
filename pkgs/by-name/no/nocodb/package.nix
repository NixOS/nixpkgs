{
  lib,
  stdenv,
  nodejs,
  pnpm,
  sqlite,
  pkg-config,
  rsync,
  makeWrapper,
  node-gyp,
  vips,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nocodb";
  version = "0.260.5";

  src = fetchFromGitHub {
    owner = "nocodb";
    repo = "nocodb";
    tag = finalAttrs.version;
    hash = "sha256-PtGrVLMZDfWykIEKHJerwnlS/UNjPhykoYYI/Ql1LtI=";
  };

  patchPhase = ''
    sed -i '/use-node-version/d' .npmrc
  '';

  buildPhase = ''
    export NODE_OPTIONS="--max_old_space_size=16384"
    export NUXT_TELEMETRY_DISABLED=1
    export npm_config_nodedir=${nodejs}

    pnpm --filter=nocodb-sdk run build
    pnpm run registerIntegrations
    pnpm --filter=nc-gui run build:copy
    pnpm --filter=nocodb run docker:build
  '';

  installPhase = ''
    mkdir -p $out/share/nocodb/packages/nocodb
    cp -v ./packages/nocodb/docker/main.js $out/share/nocodb/packages/nocodb/index.js

    # only ship nocodb workspace prod deps with node_modules (1.9GB -> 400MB)
    rm -rf ./node_modules ./packages/nocodb/node_modules
    pnpm install \
      --offline \
      --prod \
      --ignore-scripts \
      --filter=nocodb \
      --frozen-lockfile
    # waiting on upstream to add node-gyp scripts to
    # pnpm.onlyBuiltDependencies. let's handle it manually until then.
    # pnpm rebuild -r --verbose --reporter=append-only
    for package in $(find -L packages/nocodb/node_modules -name binding.gyp -type f); do
      cd "$(dirname "$package")"
      node-gyp rebuild
      cd -
    done

    # ever since nodejs 22.12.0 -> 22.13.1, pnpm keeps symlinks to unrelated
    # packages in ../packages/* in node_modules let's get rid of them manaully
    rm ./packages/nocodb/node_modules/nocodb-sdk
    for dep in ./node_modules/*; do
        [ ! -L "$dep" ] && continue;

        case "$(readlink "$dep")" in
            ../packages/*) : ;;
            ../tests/*) : ;;
            *) continue ;;
        esac

        rm $dep
    done

    cp -r ./node_modules $out/share/nocodb/node_modules
    cp -r ./packages/nocodb/node_modules $out/share/nocodb/packages/nocodb/node_modules

    makeWrapper "${lib.getExe nodejs}" "$out/bin/nocodb" \
      --set NODE_ENV production \
      --add-flags "$out/share/nocodb/packages/nocodb/index.js"
  '';

  nativeBuildInputs = [
    pnpm
    pnpm.configHook
    node-gyp

    rsync
    makeWrapper
    pkg-config
    (nodejs.python.withPackages (p: [
      p.distutils
    ]))
  ];

  buildInputs = [
    nodejs
    sqlite
    vips
  ];

  passthru.updateScript = nix-update-script { };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patchPhase
      ;
    hash = "sha256-Nc97g7c5bn49tUZKYDS/UIQDZ9rpTo1AmCgkzAgQ/94=";
  };

  meta = {
    description = "NocoDB allows building no-code database solutions with ease of spreadsheets";
    homepage = "https://nocodb.com/";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.agpl3Plus;
    mainProgram = "nocodb";
    maintainers = with lib.maintainers; [ sinanmohd ];
  };
})
