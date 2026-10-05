{
  gradient,
  nixVersions,
}:
let
  patches = map (name: "${gradient.src}/nix/patches/nix/${name}") [
    "0001-libexpr-c-expose-nix_get_derivation-and-nix_value_au.patch"
    "0002-libexpr-c-Add-C-API-function-nix_eval_state_builder_.patch"
    "0003-libflake-c-expose-nix_locked_flake_get_fingerprint.patch"
    "0004-libstore-c-expose-nix_store_add_temp_root-and-nix_st.patch"
    "0005-libexpr-c-expose-nix_eval_state_get_stats_json-via-E.patch"
    "0006-libflake-c-expose-eval-cache-AttrCursor-API-openEval.patch"
    "0007-feat-eval-cache-nix_eval_cache_commit-to-flush-cache.patch"
    "0008-feat-eval-cache-split-commit-WAL-append-from-checkpo.patch"
    "0009-fix-eval-cache-use-PASSIVE-checkpoint-so-it-never-bl.patch"
    "0010-feat-libexpr-c-nix_eval_state_get_stats-lean-counter.patch"
    "0011-fix-libexpr-c-read-counters-via-public-EvalState-get.patch"
    "0012-perf-eval-cache-memoize-rooted-paths-and-batch-conte.patch"
    "0013-style-apply-repo-clang-format-and-meson-format.patch"
    "0014-fix-eval-cache-keep-the-values-cached-under-an-attrs.patch"
    "0015-daemon-delegate-cgroup-controllers-so-builds-expose-.patch"
    "0016-libstore-name-build-cgroups-after-the-derivation-has.patch"
    "0017-libstore-keep-build-statistics-in-DerivationTrampoli.patch"
    "0018-libstore-report-cgroup-memory-io-and-oom-stats-in-Bu.patch"
    "0019-libfetchers-check-that-a-source-copied-earlier-is-st.patch"
  ];
in
((nixVersions.nixComponents_2_35.appendPatches patches).overrideScope (
  final: prev: { withAWS = false; }
)).nix-everything.overrideAttrs
  (prev: {
    strictDeps = true;
    __structuredAttrs = true;
    meta = prev.meta // {
      description = "Nix-CI for Teams (patched Nix)";
    };
  })
