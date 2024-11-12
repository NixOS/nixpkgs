# shellcheck shell=bash

# Set project.build.outputTimestamp in pom.xml to the first second of 1980 for reproducibility,
# assuming that it is not already set.
function mavenPatchPomPhase() {
  runHook preMavenPatchPomPhase

  local jarEpoch="1980-01-01T00:01:00Z"

  if @xmlstarlet@ sel -N "ns=http://maven.apache.org/POM/4.0.0" -t -m "/project/properties/project.build.outputTimestamp" -v . -n pom.xml &>/dev/null; then
    nixWarnLog "${FUNCNAME[0]}: property project.build.outputTimestamp in pom.xml already set, doing nothing"
  else
    nixInfoLog "${FUNCNAME[0]}: setting property project.build.outputTimestamp in pom.xml to $jarEpoch"
    @xmlstarlet@ ed --inplace -N "ns=http://maven.apache.org/POM/4.0.0" \
      -s "/ns:project/ns:properties" -t elem -n "project.build.outputTimestamp" -v "$jarEpoch" \
      pom.xml
  fi

  runHook postMavenPatchPomPhase
}

if [ -z "${dontPatchMavenPom-}" ]; then
  appendToVar preConfigurePhases mavenPatchPomPhase
fi
