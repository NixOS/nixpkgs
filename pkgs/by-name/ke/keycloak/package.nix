{
  stdenv,
  lib,
  fetchzip,
  makeWrapper,
  jre_headless,
  nixosTests,
  callPackage,
  confFile ? null,
  plugins ? [ ],
  extraFeatures ? [ ],
  disabledFeatures ? [ ],
}:

let
  featuresSubcommand = ''
    ${
      lib.optionalString (extraFeatures != [ ]) "--features=${lib.concatStringsSep "," extraFeatures}"
    } \
    ${lib.optionalString (
      disabledFeatures != [ ]
    ) "--features-disabled=${lib.concatStringsSep "," disabledFeatures}"}
  '';
in
stdenv.mkDerivation rec {
  pname = "keycloak";
  version = "26.1.2";

  src = fetchzip {
    url = "https://github.com/keycloak/keycloak/releases/download/${version}/keycloak-${version}.zip";
    hash = "sha256-U9g3SIh6qAQBWqIUfv1GQRqmRVzNImwCHAzfQFEFNOk=";
  };

  nativeBuildInputs = [
    makeWrapper
    jre_headless
  ];

  patches = [
    # Make home.dir and config.dir configurable through the
    # KC_HOME_DIR and KC_CONF_DIR environment variables.
    ./config_vars.patch
  ];

  buildPhase =
    ''
      runHook preBuild
    ''
    + lib.optionalString (confFile != null) ''
      install -m 0600 ${confFile} conf/keycloak.conf
    ''
    + ''
      install_plugin() {
        if [ -d "$1" ]; then
          find "$1" -type f \( -iname \*.ear -o -iname \*.jar \) -exec install -m 0500 "{}" "providers/" \;
        else
          install -m 0500 "$1" "providers/"
        fi
      }
      ${lib.concatMapStringsSep "\n" (pl: "install_plugin ${lib.escapeShellArg pl}") plugins}
    ''
    + ''
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
    enabledPlugins = plugins;
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
    ];
  };

}
