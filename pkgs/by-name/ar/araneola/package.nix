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
  guile-lib,
  guile-gnutls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "araneola";
  version = "0.0.1";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "araneola";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3fbojp3HL8tlVXtxDEdtUnJahj/n1MNXcCFEBDttaXA=";
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
    guile-lib
    guile-gnutls
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
    install -Dm755 scripts/araneola $out/bin/araneola
    install -Dm644 scripts/log.bash $out/share/scripts/log.bash
    install -Dm644 resources/help.txt $out/share/resources/help.txt
        runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/araneola \
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
          guile-lib
          guile-gnutls
        ]
      }" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteDir}:${
        lib.makeSearchPath "share/guile/site/3.0" [
          guile-scriba
          guile-lib
          guile-gnutls
        ]
      }"
  '';

  guileImportsCheck = [
    "araneola main"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/araneola";
    description = "Web crawler and sitemap generator written in GNU Guile";
    license = lib.licenses.agpl3Plus;
    mainProgram = "araneola";
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
