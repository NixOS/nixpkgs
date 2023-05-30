{ lib
, stdenv
, substituteAll
, gradle
, perl
}:

origAttrs
@
{ gradleOpts
, ... }:

let
  gradleFlags = gradleOpts.flags or [];
  gradleLockfile = gradleOpts.lockfile or null;
  lockfileTree = gradleOpts.lockfileTree or null;
  buildscriptGradleLockfile = gradleOpts.buildscriptLockfile or null;
  buildSubcommand = gradleOpts.buildSubcommand or "assemble";
  checkSubcommand = gradleOpts.checkSubcommand or "test";
  gradleDepsHash = gradleOpts.depsHash;
  gradleDepsAttrs = gradleOpts.depsAttrs or {};
  # not recommended to override, it could be a major source of impurity!
  generateMissingLockfiles = gradleOpts.generateMissingLockfiles or true;
  projectSubdir = gradleOpts.subdir or ".";
  attrs = builtins.removeAttrs origAttrs [ "gradleOpts" ];
  depsAttrs = builtins.removeAttrs attrs [ "meta" "installPhase" "preInstall" "postInstall" "preBuild" "postBuild" "fixupPhase" "preFixup" "postFixup" ];
  unknownGradleOpts = builtins.removeAttrs gradleOpts ["flags" "lockfile" "lockfileTree" "buildscriptLockfile" "buildSubcommand" "checkSubcommand" "depsHash" "depsAttrs" "subdir"];
  deps =
    assert lib.assertMsg (unknownGradleOpts == {}) "Unknown gradleOpts keys: ${builtins.toJSON (builtins.attrNames unknownGradleOpts)}";
    import ./deps.nix {
      inherit lib stdenv gradle perl lockfileTree gradleLockfile buildscriptGradleLockfile projectSubdir gradleDepsHash generateMissingLockfiles;
      gradleFlags = (gradleDepsAttrs.gradleOpts or {}).gradleFlags or gradleFlags;
      attrs = depsAttrs // gradleDepsAttrs;
    };
  gradleInit = substituteAll {
    src = ./init.gradle;
    inherit deps;
  };
in
stdenv.mkDerivation (attrs // rec {
  inherit deps;
  nativeBuildInputs = [ gradle ] ++ (attrs.nativeBuildInputs or []);
  postPatch = (if attrs?postPatch then attrs.postPatch + "\n" else "") + ''
    cd ${projectSubdir}
    projectDir=$(pwd)
    pushd "$deps/_nixLockfiles"
    for file in $(find . -type f -regex ".*\.lockfile"); do
      install -Dm755 "$file" "$projectDir/$file"
    done
    popd
    sed -i '/dependencies/,/^}/s/:-SNAPSHOT"/latest.integration/g' *.gradle **/*.gradle
    export gradle=(gradle --offline --no-daemon --init-script ${gradleInit} ${lib.escapeShellArgs gradleFlags})
  '';
  preBuild = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    export TERM=dumb
  '' + (attrs.preBuild or "");
  buildPhase = attrs.buildPhase or ''
    runHook preBuild
    "''${gradle[@]}" ${buildSubcommand}
    runHook postBuild
  '';
  checkPhase = attrs.checkPhase or ''
    runHook preCheck
    "''${gradle[@]}" ${checkSubcommand}
    runHook postCheck
  '';
  passthru = (attrs.passthru or {}) // {
    inherit deps;
  };
})
