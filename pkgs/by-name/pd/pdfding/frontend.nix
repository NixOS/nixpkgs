{
  stdenv,
  fetchNpmDeps,
  fetchzip,
  fetchFromGitHub,
  npmHooks,

  tailwindcss_4,
  nodejs,

  pdfding,
}:
let
  pdfjsVersion = "5.5.207"; # see update script
  pdfjsHash = "sha256-HikisEa6L+BqsG6imgWhV+4J46BluU5zqU1nFZAG0eM=";
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
  pname = "${pdfding.pname}-frontend";
  inherit (pdfding) src version;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    hash = "sha256-HOGnzDKg1ca/27u1oQEtOkOl6Cg/7k+aLJEJhbypUhE=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    # it is in package.json and thus node_modules but no cli executable
    tailwindcss_4
  ];

  # keeping the file structure same as upstream to minimise confusion
  buildPhase = ''
    runHook preBuild
    mkdir -p $out/pdfding
    cp -r --no-preserve=mode pdfding/static $out/pdfding/static
    cp -r --no-preserve=mode ${finalAttrs.passthru.pdfjs} $out/pdfding/static/pdfjs

    tailwindcss -i $out/pdfding/static/css/input.css -o $out/pdfding/static/css/tailwind.css --minify
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
