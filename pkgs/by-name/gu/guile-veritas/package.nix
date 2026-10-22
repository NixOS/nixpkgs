{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  guile-fibers,
  guile-json,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-veritas";
  version = "0.8.1";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "veritas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wt3HkssqoE/DBxuGYx4uazhKU1Xfv2BIrT7sfqMXHII=";
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
    guile-fibers
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
    "veritas veritas"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/veritas";
    description = "Testing framework for GNU Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
