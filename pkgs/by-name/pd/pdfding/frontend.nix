{
  stdenv,
  fetchpatch2,
  fetchNpmDeps,
  fetchzip,
  fetchFromGitHub,
  npmHooks,

  tailwindcss_4,
  nodejs,
}:
let
  pdfjsVersion = "5.4.394"; # see update script
  pdfjsHash = "sha256-pd7xwfvR9U1bHT5eblszYU3YJQwQwhuyDDiNj+fnyaQ=";
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
  version = "1.5.1";
  src = fetchFromGitHub {
    owner = "mrmn2";
    repo = "PdfDing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PXkD+2k8/LmMWzZAj8qEK4mLoOKS4mDWcqe8AgoCdBU=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "pdfding-frontend-${finalAttrs.version}-npm-deps";
    hash = "sha256-SgL8QhRGONGhJBu6b8HSVqZPzJ+NojhVClBEH5ajCcc=";
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
