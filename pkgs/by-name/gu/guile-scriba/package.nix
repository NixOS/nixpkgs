{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  guile-json,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-scriba";
  version = "0.4.1";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "scriba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RANg0gtwpKZT48QCtTn5QnVbkZSb6Xe6mD078FQT6IQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    guile
  ];
  buildInputs = [
    guile
  ];

  propagatedBuildInputs = [
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
    runHook postInstall
  '';

  guileImportsCheck = [
    "scriba scriba"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/scriba";
    description = "Structured logging framework for GNU Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
