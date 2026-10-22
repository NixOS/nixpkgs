{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  makeWrapper,
  bash,
  coreutils,
  util-linux,
  guile-dbi,
  guile-dbd-sqlite3,
  guile-dbd-mysql,
  guile-dbd-postgresql,
  guile-gcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mutastructura";
  version = "0.9.1";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "mutastructura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-13jxW9yjVYop6YZS4m9RVkERwXo3pd77HlQ0/i7wEos=";
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
    guile-dbi
    guile-dbd-sqlite3
    guile-dbd-mysql
    guile-dbd-postgresql
    guile-gcrypt
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
    install -Dm755 scripts/mutastructura $out/bin/mutastructura
    cp -R resources $out/share/resources
        runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/mutastructura \
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
          guile-dbi
          guile-dbd-sqlite3
          guile-dbd-mysql
          guile-dbd-postgresql
          guile-gcrypt
        ]
      }" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteDir}:${
        lib.makeSearchPath "share/guile/site/3.0" [
          guile-dbi
          guile-dbd-sqlite3
          guile-dbd-mysql
          guile-dbd-postgresql
          guile-gcrypt
        ]
      }" \
      --suffix GUILE_DBD_PATH : "${
        lib.makeSearchPath "lib" [
          guile-dbd-sqlite3
          guile-dbd-mysql
          guile-dbd-postgresql
        ]
      }"
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    # guileImportsCheckHook points GUILE_LOAD_PATH at $out only, which hides
    # the Guile libraries this package depends on, so ask for a module that
    # pulls in both dbi and the package's own code.
    GUILE_AUTO_COMPILE=0 \
      GUILE_LOAD_PATH="$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      guile -c '(use-modules (mutastructura persistence migration-runner))'

    runHook postCheck
  '';

  meta = {
    homepage = "https://codeberg.org/jjba23/mutastructura";
    description = "Relational database schema migrations powered by GNU Guile";
    license = lib.licenses.agpl3Plus;
    mainProgram = "mutastructura";
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
