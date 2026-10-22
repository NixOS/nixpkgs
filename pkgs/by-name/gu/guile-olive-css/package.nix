{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-olive-css";
  version = "0.6.4";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "olive-css";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vq1Pd6ZMBBXiTxWjermy+jqZHZ+JucgcjinuPzqG7Kg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    guile
  ];
  buildInputs = [
    guile
  ];

  buildPhase = ''
    runHook preBuild

    siteDir=$out/${guile.siteDir}
    install -d "$siteDir"
    cp -R src/. "$siteDir"/

    export GUILE_AUTO_COMPILE=0
    export GUILE_LOAD_PATH="$siteDir''${GUILE_LOAD_PATH:+:$GUILE_LOAD_PATH}"

    find src -name '*.scm' | while IFS= read -r file; do
      rel="''${file#src/}"
      guild compile -o "$siteDir/''${rel%.scm}.go" "$file"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  guileImportsCheck = [
    "olive-css main"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/olive-css";
    description = "Utility-first CSS framework built with GNU Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
