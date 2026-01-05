{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  testers,
  nodejs,
  node-gyp,
  inter,
  python3,
  srcOnly,
  removeReferencesTo,
  pnpm_9,
}:
let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "karakeep";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "karakeep-app";
    repo = "karakeep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KkRCMS/g+xCQyVh1qB/kf5Seqrn2McYBaUHqKOeigCA=";
  };

  patches = [
    ./patches/use-local-font.patch
    ./patches/dont-lock-pnpm-version.patch
  ];
  postPatch = ''
    ln -s ${inter}/share/fonts/truetype ./apps/web/app/fonts
  '';

  nativeBuildInputs = [
    python3
    nodejs
    node-gyp
    pnpm.configHook
  ];
  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version;

    # We need to pass the patched source code, so pnpm sees the patched version
    src = stdenv.mkDerivation {
      name = "${finalAttrs.pname}-patched-source";
      inherit (finalAttrs) src patches;
      installPhase = ''
        cp -pr --reflink=auto -- . $out
      '';
    };

    fetcherVersion = 1;
    hash = "sha256-74jLff9v2+qc09b8ArooUX6qpFt2tDNW3ZayHPcDVj0=";
  };
  buildPhase = ''
    runHook preBuild

    # Based on matrix-appservice-discord
    pushd node_modules/better-sqlite3
    npm run build-release --offline "--nodedir=${srcOnly nodejs}"
    find build -type f -exec ${removeReferencesTo}/bin/remove-references-to -t "${srcOnly nodejs}" {} \;
    popd

    export CI=true

    echo "Compiling apps/web..."
    pushd apps/web
    pnpm run build
    popd

    echo "Building apps/cli"
    pushd apps/cli
    pnpm run build
    popd

    echo "Building apps/workers"
    pushd apps/workers
    pnpm run build
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/doc/karakeep
    cp README.md LICENSE $out/share/doc/karakeep

    # Copy necessary files into lib/karakeep while keeping the directory structure
    LIB_TO_COPY="node_modules apps/web/.next/standalone apps/cli/dist apps/workers packages/db packages/shared packages/trpc"
    KARAKEEP_LIB_PATH="$out/lib/karakeep"
    for DIR in $LIB_TO_COPY; do
      mkdir -p "$KARAKEEP_LIB_PATH/$DIR"
      cp -a $DIR/{.,}* "$KARAKEEP_LIB_PATH/$DIR"
      chmod -R u+w "$KARAKEEP_LIB_PATH/$DIR"
    done

    # NextJS requires static files are copied in a specific way
    # https://nextjs.org/docs/pages/api-reference/config/next-config-js/output#automatically-copying-traced-files
    cp -r ./apps/web/public "$KARAKEEP_LIB_PATH/apps/web/.next/standalone/apps/web/"
    cp -r ./apps/web/.next/static "$KARAKEEP_LIB_PATH/apps/web/.next/standalone/apps/web/.next/"

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
    # Remove large dependencies that are not necessary during runtime
    rm -rf $out/lib/karakeep/node_modules/{@next,next,@swc,react-native,monaco-editor,faker,@typescript-eslint,@microsoft,@typescript-eslint,pdfjs-dist}

    # Remove broken symlinks
    find $out -type l ! -exec test -e {} \; -delete
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        # remove hardcoded version if upstream syncs general version with cli
        # version
        version = "0.25.0";
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://karakeep.app/";
    description = "Self-hostable bookmark-everything app (links, notes and images) with AI-based automatic tagging and full text search";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.three ];
    mainProgram = "karakeep";
    platforms = lib.platforms.linux;
  };
})
