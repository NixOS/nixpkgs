{ lib, runCommand, dos2unix }:

{ gitSource
, src
, testName ? "check-source-equivalence-${gitSource.name}-vs-${src.name}"
}:

runCommand testName {
} ''
  touch "$out"
  mkdir -p tested/
  tar xvf ${src} -C tested/ &>/dev/null
  diff --brief --recursive --new-file --unified ${gitSource} tested/xz-5.6.1
''
