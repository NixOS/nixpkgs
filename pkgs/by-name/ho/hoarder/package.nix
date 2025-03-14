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
}:
let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hoarder";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "hoarder-app";
    repo = "hoarder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SYcJfobuDl2iPXy5qGGG8ukBX/CSboSo/hF2e/8ixVw=";
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
      phases = [
        "unpackPhase"
        "patchPhase"
        "installPhase"
      ];
      src = finalAttrs.src;
      patches = finalAttrs.patches;
      installPhase = "cp -pr --reflink=auto -- . $out";
    };

    hash = "sha256-4MSNh2lyl0PFUoG29Tmk3WOZSRnW8NBE3xoppJr8ZNY=";
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

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/doc/hoarder
    cp README.md LICENSE $out/share/doc/hoarder

    # Copy necessary files into lib/hoarder while keeping the directory structure
    LIB_TO_COPY="node_modules apps/web/.next/standalone apps/cli/dist apps/workers packages/db packages/shared packages/trpc"
    HOARDER_LIB_PATH="$out/lib/hoarder"
    for DIR in $LIB_TO_COPY; do
      mkdir -p "$HOARDER_LIB_PATH/$DIR"
      cp -a $DIR/{.,}* "$HOARDER_LIB_PATH/$DIR"
      chmod -R u+w "$HOARDER_LIB_PATH/$DIR"
    done

    # NextJS requires static files are copied in a specific way
    # https://nextjs.org/docs/pages/api-reference/config/next-config-js/output#automatically-copying-traced-files
    cp -r ./apps/web/public "$HOARDER_LIB_PATH/apps/web/.next/standalone/apps/web/"
    cp -r ./apps/web/.next/static "$HOARDER_LIB_PATH/apps/web/.next/standalone/apps/web/.next/"

    # Copy and patch helper scripts
    for HELPER_SCRIPT in ${./helpers}/*; do
      HELPER_SCRIPT_NAME="$(basename "$HELPER_SCRIPT")"
      cp "$HELPER_SCRIPT" "$HOARDER_LIB_PATH/"
      substituteInPlace "$HOARDER_LIB_PATH/$HELPER_SCRIPT_NAME" \
        --replace-warn "HOARDER_LIB_PATH=" "HOARDER_LIB_PATH=$HOARDER_LIB_PATH" \
        --replace-warn "RELEASE=" "RELEASE=${finalAttrs.version}" \
        --replace-warn "NODEJS=" "NODEJS=${nodejs}"
      chmod +x "$HOARDER_LIB_PATH/$HELPER_SCRIPT_NAME"
      patchShebangs "$HOARDER_LIB_PATH/$HELPER_SCRIPT_NAME"
    done

    # The cli should be in bin/
    mkdir -p $out/bin
    mv "$HOARDER_LIB_PATH/hoarder-cli" $out/bin/

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    # Remove large dependencies that are not necessary during runtime
    rm -rf $out/lib/hoarder/node_modules/{@next,next,@swc,react-native,monaco-editor,faker,@typescript-eslint,@microsoft,@typescript-eslint,pdfjs-dist}

    # Remove broken symlinks
    find $out -type l ! -exec test -e {} \; -delete

    runHook postFixup
  '';

  meta = {
    homepage = "https://github.com/hoarder-app/hoarder";
    description = "Self-hostable bookmark-everything app with a touch of AI for the data hoarders out there";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.three ];
    platforms = lib.platforms.linux;
  };
})
