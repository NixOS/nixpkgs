{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  node-gyp,
  inter,
  python3,
  srcOnly,
  removeReferencesTo,
  pnpm_9,
  ncc,
}:
let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "karakeep";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "karakeep-app";
    repo = "karakeep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cm6e1XEmMHzQ3vODxa9+Yuwt+9zLvQ9S7jmwAozjA/k=";
  };

  patches = [
    ./patches/use-local-font.patch
    ./patches/fix-migrations-path.patch
    ./patches/dont-lock-pnpm-version.patch
  ];
  postPatch = ''
    ln -s ${inter}/share/fonts/truetype ./apps/landing/app/fonts
    ln -s ${inter}/share/fonts/truetype ./apps/web/app/fonts
  '';

  nativeBuildInputs = [
    pnpm.configHook

    python3
    nodejs
    node-gyp
    ncc
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version;
    src = stdenv.mkDerivation {
      name = "${finalAttrs.pname}-patched-source";
      inherit (finalAttrs) src patches;
      installPhase = ''
        cp -pr --reflink=auto -- . $out
      '';
    };
    hash = "sha256-HZb11CAbnlGSmP/Gxyjncd/RuIWkPv3GvwYs9QZ12Ss=";
  };

  buildPhase = ''
    export CI=true
    export NEXT_TELEMETRY_DISABLED=1
    export PUPPETEER_SKIP_DOWNLOAD=true

    (
      # Based on matrix-appservice-discord
      cd node_modules/better-sqlite3
      npm run build-release --offline "--nodedir=${srcOnly nodejs}"
      find build -type f -exec ${removeReferencesTo}/bin/remove-references-to -t "${srcOnly nodejs}" {} \;
    )

    ( cd apps/web; pnpm run build )
    ( cd apps/cli; pnpm run build )
    ( cd packages/db; ncc build migrate.ts -o ./db_migrations )

    runHook postBuild
  '';

  preInstall = ''
    # Remove dev dependencies
    pnpm --ignore-scripts --prod prune

    # Remove large dependencies that are not necessary during runtime
    rm -rf node_modules/{@next,next,@swc,react-native,monaco-editor,faker,@typescript-eslint,@microsoft,@typescript-eslint,pdfjs-dist,@hoarder/prettier-config}

    # Remove broken symlinks
    find . -type l ! -exec test -e {} \; -delete
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/doc/karakeep
    cp README.md LICENSE $out/share/doc/karakeep

    KARAKEEP_LIB_PATH="$out/lib/karakeep"
    mkdir -p "$KARAKEEP_LIB_PATH"

    # Shared node_modules (needed for Workers)
    cp -a ./node_modules "$KARAKEEP_LIB_PATH/node_modules"
    chmod -R u+w "$KARAKEEP_LIB_PATH/node_modules"

    # Workers
    cp -a ./apps/workers "$KARAKEEP_LIB_PATH/workers"
    chmod -R u+w "$KARAKEEP_LIB_PATH/workers"

    # Migrations
    mv ./packages/db/db_migrations "$KARAKEEP_LIB_PATH/db_migrations"

    # Web
    # https://nextjs.org/docs/pages/api-reference/config/next-config-js/output#automatically-copying-traced-files
    mv ./apps/web/.next/standalone "$KARAKEEP_LIB_PATH/web"
    cp -r ./apps/web/public "$KARAKEEP_LIB_PATH/web/apps/web/"
    cp -r ./apps/web/.next/static "$KARAKEEP_LIB_PATH/web/apps/web/.next/"

    # CLI
    mkdir -p "$KARAKEEP_LIB_PATH/cli"
    mv apps/cli/dist/index.mjs "$KARAKEEP_LIB_PATH/cli/index.mjs"

    # Copy and patch helper scripts
    for HELPER_SCRIPT in ${./helpers}/*; do
      HELPER_SCRIPT_NAME="$(basename "$HELPER_SCRIPT")"
      cp "$HELPER_SCRIPT" "$KARAKEEP_LIB_PATH/"
      substituteInPlace "$KARAKEEP_LIB_PATH/$HELPER_SCRIPT_NAME" \
        --replace-warn "KARAKEEP_LIB_PATH=" "KARAKEEP_LIB_PATH=$KARAKEEP_LIB_PATH" \
        --replace-warn "RELEASE=" "RELEASE=${finalAttrs.version}" \
        --replace-warn "NODEJS=" "NODEJS=${nodejs}"
      chmod +x "$KARAKEEP_LIB_PATH/$HELPER_SCRIPT_NAME"
      patchShebangs "$KARAKEEP_LIB_PATH/$HELPER_SCRIPT_NAME"
    done

    # The cli should be in bin/
    mkdir -p $out/bin
    mv "$KARAKEEP_LIB_PATH/karakeep" $out/bin/

    runHook postInstall
  '';

  postFixup = ''
    # Remove broken symlinks
    find $out -type l ! -exec test -e {} \; -delete
  '';

  meta = {
    homepage = "https://karakeep.app/";
    description = "Self-hostable bookmark-everything app (links, notes and images) with AI-based automatic tagging and full text search";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.three ];
    mainProgram = "karakeep";
    platforms = lib.platforms.linux;
  };
})
