{
  lib,
  stdenv,
  fetchFromCodeberg,
  gobject-introspection,
  gtk3,
  guile,
  guile-gi,
  makeBinaryWrapper,
  unstableGitUpdater,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schemacs";
  version = "0-unstable-2026-10-04";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ramin_hal9001";
    repo = "schemacs";
    rev = "9840ec0291b52e6f58bf97eaff5617b94edc8ce3";
    hash = "sha256-aDcfmHx3ZS6pD6peXq2P0lyv2rFrTdBqMrPrMHky/2w=";
  };

  # Find the bundled Emacs Lisp sources outside of the source tree
  postPatch = ''
    substituteInPlace schemacs/elisp-eval.sld \
      --replace-fail '"./elisp/' "\"$out/share/schemacs/elisp/"

    # Some callers still use the name the text buffer API had before
    # insert-string and insert-char were merged into insert, which crashes
    # the GUI whenever it shows a message, for example on an unbound key
    substituteInPlace schemacs/apps/debugui.sld schemacs/apps/emacs.sld \
      --replace-fail '(impl/insert-string ' '(impl/insert '
  '';

  strictDeps = true;

  nativeBuildInputs = [
    gobject-introspection
    guile
    makeBinaryWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    guile
    guile-gi
  ];

  # Libraries that are tests, or that do not compile at this revision
  brokenLibraries = [
    "chibi/match-test.sld"
    "schemacs/backend/guile/elisp.sld"
    "schemacs/elisp-eval/buffer.sld"
    "schemacs/sim-agent.sld"
  ];

  buildPhase = ''
    runHook preBuild

    export GUILE_AUTO_COMPILE=0
    find chibi rapid schemacs slib -name '*.sld' | sort | while read -r lib; do
      if [[ " ''${brokenLibraries[*]} " == *" $lib "* ]]; then
        continue
      fi
      guild compile --r7rs -L . -o "ccache/''${lib%.sld}.go" "$lib"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/schemacs $out/lib/schemacs
    cp -r chibi elisp rapid schemacs slib main-gui.scm $out/share/schemacs
    cp -r ccache $out/lib/schemacs

    runHook postInstall
  '';

  dontWrapGApps = true;

  postFixup = ''
    makeBinaryWrapper ${lib.getExe guile} $out/bin/schemacs \
      "''${gappsWrapperArgs[@]}" \
      --prefix GUILE_LOAD_PATH : "$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$GUILE_LOAD_COMPILED_PATH" \
      --prefix GUILE_EXTENSIONS_PATH : "$GUILE_EXTENSIONS_PATH" \
      --add-flags "--no-auto-compile --r7rs" \
      --add-flags "-L $out/share/schemacs -C $out/lib/schemacs/ccache" \
      --add-flags "$out/share/schemacs/main-gui.scm"
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Clone of Emacs and Emacs Lisp written in R7RS Scheme";
    homepage = "https://codeberg.org/ramin_hal9001/schemacs";
    license = with lib.licenses; [
      agpl3Plus
      gpl3Plus # Bundled Emacs Lisp sources and (rapid) libraries
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "schemacs";
    inherit (guile.meta) platforms;
  };
})
