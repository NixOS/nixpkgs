{
  nixVersions,
  src,
}:
let
  patches = map (name: "${src}/nix/patches/nix/${name}") [
    "0003-libflake-c-expose-nix_locked_flake_get_fingerprint.patch"
    "0004-libstore-c-expose-nix_store_add_temp_root-and-nix_st.patch"
    "0005-libexpr-make-the-evaluation-statistics-readable-with.patch"
    "0006-libexpr-c-expose-nix_eval_state_get_stats-and-nix_ev.patch"
    "0007-libflake-c-expose-the-evaluation-cache-of-a-locked-f.patch"
    "0009-libexpr-memoize-rooted-paths-in-the-evaluation-cache.patch"
    "0010-libexpr-let-concurrent-evaluators-share-an-evaluatio.patch"
    "0011-libexpr-evaluate-a-failed-attribute-again-instead-of.patch"
    "0014-libstore-keep-build-statistics-in-DerivationTrampoli.patch"
    "0015-libstore-report-cgroup-memory-io-and-oom-stats-in-Bu.patch"
    "0016-libstore-add-build-resource-usage-worker-protocol-fe.patch"
    "0017-libfetchers-check-that-a-source-copied-earlier-is-st.patch"
    "0018-libexpr-replay-a-failed-realisation-instead-of-build.patch"
    "0019-libexpr-let-the-embedder-realise-an-import-from-deri.patch"
    "0020-libexpr-let-the-embedder-fetch.patch"
    "0021-libstore-c-expose-nix_store_get_system_features.patch"
    "0022-libutil-libexpr-include-headers-libc-omits.patch"
    "0023-libflake-include-rev-in-flake-fingerprint.patch"
    "0024-libstore-start-transactions-that-read-before-they-wr.patch"
  ];
in
((nixVersions.nixComponents_2_36.appendPatches patches).overrideScope (
  final: prev: { withAWS = false; }
)).nix-everything.overrideAttrs
  (prev: {
    strictDeps = true;
    __structuredAttrs = true;
    meta = prev.meta // {
      description = "Nix-CI for Teams (patched Nix)";
    };
  })
