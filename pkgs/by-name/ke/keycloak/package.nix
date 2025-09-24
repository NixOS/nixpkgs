{
  lib,
  stdenv,
  fetchzip,
  makeBinaryWrapper,
  jre_headless,
  nixosTests,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keycloak";
  version = "26.3.4";

  src = fetchzip {
    url = "https://github.com/keycloak/keycloak/releases/download/${finalAttrs.version}/keycloak-${finalAttrs.version}.zip";
    hash = "sha256-K+7ZUBN3iYGMteP/ycu4M5rJPdIavN144BgOwktdu3g=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    jre_headless
  ];

  patches = [
    # Make home.dir and config.dir configurable through the
    # KC_HOME_DIR and KC_CONF_DIR environment variables.
    ./config_vars.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out

    rm $out/bin/*.{ps1,bat,orig}

    runHook postInstall
  '';

  postFixup = ''
    for script in $(find $out/bin -type f -executable); do
      wrapProgram "$script" --set JAVA_HOME ${jre_headless} --prefix PATH : ${jre_headless}/bin
    done
  '';

  passthru = {
    tests = nixosTests.keycloak;
    plugins = callPackage ./all-plugins.nix { };
  };

  meta = {
    homepage = "https://www.keycloak.org/";
    description = "Identity and access management for modern applications and services";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = jre_headless.meta.platforms;
    maintainers = with lib.maintainers; [
      ngerstle
      talyz
      nickcao
      leona
    ];
  };
})
