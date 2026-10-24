{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  guile-gcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-uuid";
  version = "0.9.1";

  src = fetchFromCodeberg {
    owner = "elb";
    repo = "guile-uuid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bb+oh21dWoYyYYdpZdCJ7bvd4run7nQFYF9VqT9S/wU=";
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
    guile-gcrypt
  ];

  buildPhase = ''
    runHook preBuild

    siteDir=$out/${guile.siteDir}
    install -d "$siteDir"
    cp -R uuid "$siteDir"/

    export GUILE_AUTO_COMPILE=0
    export GUILE_LOAD_PATH="$siteDir''${GUILE_LOAD_PATH:+:$GUILE_LOAD_PATH}"

    find uuid -name '*.scm' | while IFS= read -r file; do
      guild compile -o "$siteDir/''${file%.scm}.go" "$file"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  guileImportsCheck = [
    "uuid generate"
  ];

  meta = {
    homepage = "https://codeberg.org/elb/guile-uuid";
    description = "UUID generation and manipulation library for GNU Guile";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
