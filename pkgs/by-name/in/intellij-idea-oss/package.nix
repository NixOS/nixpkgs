{
  # keep-sorted start
  fsnotifier,
  jetbrains,
  lib,
  maven,
  stdenv,
  zlib,
  # keep-sorted end
}:
let
  src = jetbrains.mkJetBrainsSource (
    lib.importJSON ./source_args.json
    // {
      mvnDeps = ./maven_artefacts.json;
    }
  );
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

  pname = "intellij-idea-oss";

  wmClass = "jetbrains-idea-ce";
  product = "IntelliJ IDEA Open Source";
  productShort = "IDEA";

  extraLdPath = [ zlib ];
  extraWrapperArgs = [
    ''--set M2_HOME "${maven}/maven"''
    ''--set M2 "${maven}/maven/bin"''
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/idea/";
    description = "Free Java, Kotlin, Groovy and Scala IDE from JetBrains (built from source)";
    longDescription = ''
      IDE for Java SE, Groovy & Scala development Powerful environment for building Google Android apps Integration with JUnit, TestNG, popular SCMs, Ant & Maven.
      Also known as IntelliJ.
    '';
    maintainers = with lib.maintainers; [
      gytis-ivaskevicius
      tymscar
    ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    knownVulnerabilities = [
      ''
        This version of IDEA has multiple known security vulnerabilities, see NIXPKGS-2026-2269: https://tracker.security.nixos.org/issues/NIXPKGS-2026-2269.
        The package `jetbrains.idea-oss` is currently not receiving updates in nixpkgs, consider using `jetbrains.idea`.
      ''
    ];
  };
}
