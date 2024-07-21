{
  stdenv,
  lib,
  fetchFromGitHub,
  maven,
  pnpm_9,
  makeWrapper,
  jre,
  nodejs,
  nixosTests,
  callPackage,
  confFile ? null,
  plugins ? [ ],
  extraFeatures ? [ ],
  disabledFeatures ? [ ],
  stdenvNoCC,
}:

let
  pnpm = pnpm_9;
  featuresSubcommand = ''
    ${lib.optionalString (extraFeatures != [ ]) "--features=${lib.concatStringsSep "," extraFeatures}"} \
    ${lib.optionalString (disabledFeatures != [ ]) "--features-disabled=${lib.concatStringsSep "," disabledFeatures}"}
  '';

  pname = "keycloak";
  version = "25.0.2";

  src = fetchFromGitHub {
    owner = "keycloak";
    repo = "keycloak";
    rev = "refs/tags/${version}";
    hash = "sha256-7YJjOChUC5HScNdU5XXp3gDparRCKtj1s2FQwyp6RPI=";
  };

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "keycloak-frontend";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-r1ZY3pK1ljWZ/N87a4fvn6mDfkRJWs+IF/G2wu3Ojzc=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -r . $out/

      runHook postInstall
    '';

  });
in
maven.buildMavenPackage rec {
  inherit pname version src;

  patches = [ ./disable-pnpm-install.patch ];

  mvnHash = "sha256-mJvZ7OQVf9/dgIjb+k5Kg+2O0SGQ8XJwjM7UtcTrQXY=";

  mvnParameters = lib.escapeShellArgs [
    "-Pdistribution"
    "-DskipTestsuite"
    "-DskipTests"
  ];

  nativeBuildInputs = [
    jre
    makeWrapper
  ];

  configurePhase = ''
    runHook preConfigure
    ln -s "${frontend}" node_modules
    runHook postConfigure
  '';

  #patches = [
  #  # Make home.dir and config.dir configurable through the
  #  # KC_HOME_DIR and KC_CONF_DIR environment variables.
  #  ./config_vars.patch
  #];

  buildPhase = ''
    runHook preBuild
  '' + lib.optionalString (confFile != null) ''
    install -m 0600 ${confFile} conf/keycloak.conf
  '' + ''
    install_plugin() {
      if [ -d "$1" ]; then
        find "$1" -type f \( -iname \*.ear -o -iname \*.jar \) -exec install -m 0500 "{}" "providers/" \;
      else
        install -m 0500 "$1" "providers/"
      fi
    }
    ${lib.concatMapStringsSep "\n" (pl: "install_plugin ${lib.escapeShellArg pl}") plugins}
  '' + ''
    patchShebangs bin/kc.sh
    export KC_HOME_DIR=$(pwd)
    export KC_CONF_DIR=$(pwd)/conf
    bin/kc.sh build ${featuresSubcommand}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out

    rm $out/bin/*.{ps1,bat}

    runHook postInstall
  '';

  postFixup = ''
    for script in $(find $out/bin -type f -executable); do
      wrapProgram "$script" --set JAVA_HOME ${jre} --prefix PATH : ${jre}/bin
    done
  '';

  passthru = {
    tests = nixosTests.keycloak;
    plugins = callPackage ./all-plugins.nix { };
    enabledPlugins = plugins;
  };

  meta = {
    homepage = "https://www.keycloak.org";
    description = "Identity and access management for modern applications and services";
    license = lib.licenses.asl20;
    platforms = jre.meta.platforms;
    maintainers = with lib.maintainers; [ ngerstle talyz nickcao ];
    mainProgram = "kc.sh";
  };

}
