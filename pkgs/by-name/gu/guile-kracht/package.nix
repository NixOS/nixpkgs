{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-kracht";
  version = "0.3.1";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "kracht";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DjksuqjdY44vdS1QGTS5BbbU+FE21tR/OCkVbWAZy30=";
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
    "kracht strings"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/kracht";
    description = "Utility library for GNU Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
