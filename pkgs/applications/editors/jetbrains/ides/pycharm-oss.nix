{
  # keep-sorted start
  fsnotifier,
  jetbrains,
  lib,
  python3,
  stdenv,
  # keep-sorted end
}:
let
  src = jetbrains.mkJetBrainsSource {
    # update-script-start: source-args
    version = "2025.3.3";
    buildNumber = "253.31033.139";
    buildType = "pycharm";
    ideaHash = "sha256-GRlWzpHvgy7P+vw+UWApyPpLLzWiHmvsC8HLPUyrshQ=";
    androidHash = "sha256-FA/6ry1M7+RISJL+2SR9QkDvAGJAkXhFMh9YoOEU5nk=";
    jpsHash = "sha256-iHpt926BDLNUwHRXvkqVgwlWiLo1qSZEaGeJcS0Fjmk=";
    restarterHash = "sha256-acCmC58URd6p9uKZrm0qWgdZkqu9yqCs23v8qgxV2Ag=";
    mvnDeps = ../source/pycharm_maven_artefacts.json;
    repositories = [
      "repo1.maven.org/maven2"
      "packages.jetbrains.team/maven/p/ij/intellij-dependencies"
      "dl.google.com/dl/android/maven2"
      "download.jetbrains.com/teamcity-repository"
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
jetbrains.mkJetBrainsProduct {
  inherit src fsnotifier;
  inherit (src)
    version
    buildNumber
    ;
  # this is jetbrains-libdbm but using the sources from the IDE build.
  jetbrains-libdbm = src.libdbm;

  # the jdk is bundled on Darwin.
  jdk = if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk then jetbrains.jdk else null;

  pname = "pycharm-oss";

  wmClass = "jetbrains-pycharm-ce";
  product = "PyCharm Open Source";
  productShort = "PyCharm";

  nativeBuildInputs = [
    # keep-sorted start
    jetbrains.cythonDebugSpeedupsHook
    python3
    python3.pkgs.setuptools
    # keep-sorted end
  ];

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
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    knownVulnerabilities = [
      ''
        This version of PyCharm has multiple known security vulnerabilities, see NIXPKGS-2026-2269: https://tracker.security.nixos.org/issues/NIXPKGS-2026-2269.
        The package `jetbrains.pycharm-oss` is currently not receiving updates in nixpkgs, consider using `jetbrains.pycharm`.
      ''
    ];
  };
}
