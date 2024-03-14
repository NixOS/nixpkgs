{ lib
, runCommandLocal
  # Test targets
, writeClosure
, samples
}:
runCommandLocal "test-trivial-builders-writeClosure-mixed" {
  __structuredAttrs = true;
  references = lib.mapAttrs (n: v: writeClosure [ v ]) samples;
  allRefs = writeClosure (lib.attrValues samples);
  inherit samples;
  meta.maintainers = with lib.maintainers; [
    ShamrockLee
  ];
} ''
  set -eu -o pipefail
  echo >&2 Testing mixed closures...
  echo >&2 Checking all samples "(''${samples[*]})" "$allRefs"
  diff -U3 \
    <(sort <"$allRefs") \
    <(cat "''${references[@]}" | sort | uniq)
  touch "$out"
''
