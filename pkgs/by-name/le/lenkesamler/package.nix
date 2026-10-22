{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  makeWrapper,
  bash,
  coreutils,
  util-linux,
  guile-json,
  guile-gnutls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lenkesamler";
  version = "0.0.2";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "lenkesamler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3jrH0xObNjiK7RyEA6dAjWdEIGGqD1NbyRjjyLIU0xY=";
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
    guile-json
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
    install -Dm755 scripts/lenkesamler $out/bin/lenkesamler
    install -Dm644 scripts/log.bash $out/share/scripts/log.bash
    install -Dm644 resources/help.txt $out/share/resources/help.txt
        runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/lenkesamler \
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
          guile-json
          guile-gnutls
        ]
      }" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteDir}:${
        lib.makeSearchPath "share/guile/site/3.0" [
          guile-json
          guile-gnutls
        ]
      }"
  '';

  guileImportsCheck = [
    "lenkesamler main"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/lenkesamler";
    description = "Bookmark manager, sync tool and digital archive";
    license = lib.licenses.agpl3Plus;
    mainProgram = "lenkesamler";
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
