{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  guile-uuid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-hygguile";
  version = "2.7.3";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "hygguile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dmtBeT0E6/17W5cBax/sM3kd9fPgFxvbMLFTTvJqWWQ=";
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
    guile-uuid
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
    "hygguile hygguile"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/hygguile";
    description = "Web UI component library for GNU Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
