{
  lib,
  anki-utils,
  fetchFromGitHub,
  esbuild,
  aab,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "review-heatmap";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "glutanimate";
    repo = "review-heatmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CL98DYikumoPR/QTWcMMwpd/tEpKLIDVC1Rj5NEvWJ8=";
    # Needed files are set to export-ignore in .gitattributes
    forceFetchGit = true;
  };

  patches = [ ./0001-Apply-vite-style-to-anki-review-heatmap.js.patch ];

  nativeBuildInputs = [
    aab
    esbuild
  ];

  buildPhase = ''
    runHook preBuild

    # Work around missing icons
    mkdir resources/icons/optional
    touch resources/icons/optional/{patreon.svg,thanks.svg,twitter.svg,youtube.svg}

    mkdir -p build/dist
    cp -r src resources designer --target-directory build/dist
    aab build_dist ${finalAttrs.version} --modtime -1

    # build anki-review-heatmap.js
    esbuild \
      src/web/main.ts \
      --bundle \
      --minify \
      --target=es2015 \
      --loader:.css=text \
      --outfile=build/dist/src/review_heatmap/web/anki-review-heatmap.js

    cd build/dist/src/review_heatmap

    runHook postBuild
  '';

  meta = {
    description = "Anki add-on to help you keep track of your review activity";
    homepage = "https://github.com/glutanimate/review-heatmap";
    changelog = "https://github.com/glutanimate/review-heatmap/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
