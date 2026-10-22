{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  guile-uuid,
  guile-gcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-bewaking";
  version = "0.4.2";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "bewaking";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dSRvPeDR1luPfyjL4F1jMDkt5Dnb9HavD/km8p0qL8M=";
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
    runHook postInstall
  '';

  guileImportsCheck = [
    "bewaking bewaking"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/bewaking";
    description = "Authentication and authorization library for GNU Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
