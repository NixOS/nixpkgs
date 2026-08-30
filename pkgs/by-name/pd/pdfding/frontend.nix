{
  stdenv,
  fetchNpmDeps,
  fetchzip,
  npmHooks,

  nodejs,
  pdfding,
}:
let
  pdfjsVersion = "6.1.200"; # see update script
  pdfjsHash = "sha256-8hByPf4BXTXakRxomXtknthlCLcjG/pCLVnjMxqrROI=";
  pdfjs = fetchzip {
    url = "https://github.com/mozilla/pdf.js/releases/download/v${pdfjsVersion}/pdfjs-${pdfjsVersion}-dist.zip";
    hash = pdfjsHash;
    stripRoot = false;
    postFetch = ''
      rm -rf $out/web/locale \
      $out/web/standard_fonts \
      $out/web/compressed.tracemonkey-pldi-09.pdf

      # remove source maps
      find "$out" -name '*.map' -exec rm -f '{}' \;
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pdfding-frontend";
  inherit (pdfding) src version;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "pdfding-${finalAttrs.version}-npm-deps";
    hash = "sha256-4mnw9sLQBZCBqmTKkjNHx03pgmvQ4CuDg3NOke4vMHs=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # keeping the file structure same as upstream to minimise confusion
  buildPhase = ''
    runHook preBuild
    mkdir -p $out/pdfding
    cp -r --no-preserve=mode pdfding/static $out/pdfding/static
    cp -r --no-preserve=mode ${finalAttrs.passthru.pdfjs} $out/pdfding/static/pdfjs

    # NOTE: Directly using tailwindcss package from nixpkgs gave a `Trace/BPT trap: 5` error on darwin
    # Trace/BPT trap: 5 tailwindcss -i $out/pdfding/static/css/input.css -o $out/pdfding/static/css/tailwind.css --minify
    # It didn't occur when building the package in an interactive ssh session but on nixpkgs-review-gha it failed consistently
    # https://github.com/NixOS/nixpkgs/pull/540436#issuecomment-4942029413

    node node_modules/@tailwindcss/cli/dist/index.mjs -i pdfding/static/css/input.css -o $out/pdfding/static/css/tailwind.css --minify
    rm $out/pdfding/static/css/input.css

    for i in build/pdf.mjs build/pdf.sandbox.mjs build/pdf.worker.mjs web/viewer.mjs;
    do
      node_modules/terser/bin/terser $out/pdfding/static/pdfjs/$i --compress -o $out/pdfding/static/pdfjs/$i;
    done

    npm run build

    cp -r pdfding/static/js $out/pdfding/static

    runHook postBuild
  '';

  passthru = {
    inherit pdfjs;
  };

  meta = {
    description = "PdfDing frontend";
  };
})
