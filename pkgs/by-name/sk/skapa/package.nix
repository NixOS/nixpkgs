{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  makeWrapper,
  bash,
  coreutils,
  util-linux,
  guile-scriba,
  guile-json,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skapa";
  version = "0.0.3";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "skapa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SZaXo3Dye172CjLPKMiPQ3grj2tFF8p+n10CbWKrxrs=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    guile
    makeWrapper
  ];
  buildInputs = [
    guile
  ];

  propagatedBuildInputs = [
    guile-scriba
    guile-json
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
    install -Dm755 scripts/skapa $out/bin/skapa
    install -Dm644 resources/help.txt $out/share/resources/help.txt
    cp -R resources/templates $out/share/resources/templates
    cp -R resources/licenses $out/share/resources/licenses
        runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/skapa \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          util-linux
          guile
        ]
      } \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:${
        lib.makeSearchPath "share/guile/site/3.0" [
          guile-scriba
          guile-json
        ]
      }" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteDir}:${
        lib.makeSearchPath "share/guile/site/3.0" [
          guile-scriba
          guile-json
        ]
      }"
  '';

  guileImportsCheck = [
    "skapa main"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/skapa";
    description = "Project scaffolder and templating engine";
    license = lib.licenses.gpl3Plus;
    mainProgram = "skapa";
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
