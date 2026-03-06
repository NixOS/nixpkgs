{
  lib,
  mkJetBrainsProduct,
  mkJetBrainsSource,
  pyCharmCommonOverrides,
}:
let
  src = mkJetBrainsSource {
    # update-script-start: source-args
    version = "2025.3.2.1";
    buildNumber = "253.30387.173";
    buildType = "pycharm";
    ideaHash = "sha256-13da6xCaZfS7zwesqGJpwsKfUK61Vi7gtMgPKtve43U=";
    androidHash = "sha256-FA/6ry1M7+RISJL+2SR9QkDvAGJAkXhFMh9YoOEU5nk=";
    jpsHash = "sha256-iHpt926BDLNUwHRXvkqVgwlWiLo1qSZEaGeJcS0Fjmk=";
    restarterHash = "sha256-acCmC58URd6p9uKZrm0qWgdZkqu9yqCs23v8qgxV2Ag=";
    mvnDeps = ../source/pycharm_maven_artefacts.json;
    repositories = [
      "repo1.maven.org/maven2"
      "packages.jetbrains.team/maven/p/ij/intellij-dependencies"
      "dl.google.com/dl/android/maven2"
      "download.jetbrains.com/teamcity-repository"
      "maven.pkg.jetbrains.space/kotlin/p/kotlin/kotlin-ide-plugin-dependencies"
      "packages.jetbrains.team/maven/p/grazi/grazie-platform-public"
      "packages.jetbrains.team/maven/p/kpm/public"
      "packages.jetbrains.team/maven/p/ki/maven"
      "maven.pkg.jetbrains.space/public/p/compose/dev"
      "packages.jetbrains.team/maven/p/amper/amper"
      "packages.jetbrains.team/maven/p/kt/bootstrap"
    ];
    kotlin-jps-plugin = {
      version = "2.2.20";
      hash = "sha256-+jGghK2+yq+YFm5zT7ob+WTgTiJnHXAjDtlZjOzSISQ=";
    };
    # update-script-end: source-args
  };
in
(mkJetBrainsProduct {
  inherit src;
  inherit (src)
    version
    buildNumber
    libdbm
    fsnotifier
    ;

  pname = "pycharm-oss";

  wmClass = "jetbrains-pycharm-ce";
  product = "PyCharm Open Source";
  productShort = "PyCharm";

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/pycharm/";
    description = "Free Python IDE from JetBrains (built from source)";
    longDescription = ''
      Python IDE with complete set of tools for productive development with Python programming language.
      In addition, the IDE provides high-class capabilities for professional Web development with Django framework and Google App Engine.
      It has powerful coding assistance, navigation, a lot of refactoring features, tight integration with various Version Control Systems, Unit testing and powerful Debugger.
    '';
    maintainers = with lib.maintainers; [
      tymscar
    ];
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}).overrideAttrs
  pyCharmCommonOverrides
