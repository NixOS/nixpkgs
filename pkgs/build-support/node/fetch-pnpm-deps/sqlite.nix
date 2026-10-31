{
  lib,
  fetchpatch,
  fetchurl,
  sqlite,
}:

# SQLite 3.53.0 changed both the raw database written through `node:sqlite`
# (used by pnpm 11 for the store index, archived as is with `fetcherVersion = 3`)
# and the `.dump` output (BLOBs as `x'...'` instead of `X'...'`, used with `fetcherVersion >= 4`).
# Both end up in the output of `fetchPnpmDeps`, so bumping SQLite on release-26.05 broke existing hashes.
# Pin the version that was used when those hashes were generated.
# This is only used to produce the fetcher output, never at runtime.
let
  archiveVersion = import ../../../development/libraries/sqlite/archive-version.nix lib;
in
sqlite.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "3.51.2";

    src = fetchurl {
      url = "https://sqlite.org/2026/sqlite-src-${archiveVersion finalAttrs.version}.zip";
      hash = "sha256-hREPdi1QeUFNmd1deRe8P/fgWHbmzL0T2ElqOBfyCCk=";
    };
    docsrc = fetchurl {
      url = "https://sqlite.org/2026/sqlite-doc-${archiveVersion finalAttrs.version}.zip";
      hash = "sha256-xuMNB8XpwSaQHFTY18kKnBo3B4JFUX8GCzxpxN5Dv10=";
    };

    # The patches of `sqlite` are for 3.53.x
    patches = [
      # CVE-2026-11822, CVE-2026-11824: heap buffer overflow in FTS5 with a crafted database.
      # Not reachable here, as the fetcher only processes the pnpm store index, which has no FTS5 tables,
      # but patch it anyway to not ship a known vulnerable SQLite.
      (fetchpatch {
        name = "CVE-2026-11822-CVE-2026-11824.patch";
        url = "https://github.com/sqlite/sqlite/commit/79db323ce14923a1bcc7b3b72679003c14c1cd7f.patch";
        includes = [ "ext/fts5/fts5_index.c" ];
        hash = "sha256-cC+arSFkf7usdQzbefhCp+J5NHWNIsaB84NHncHNEhI=";
      })
    ];
    postPatch = "";

    postInstall = ''
      mkdir -p $doc/share/doc
      unzip $docsrc
      mv sqlite-doc-${archiveVersion finalAttrs.version} $doc/share/doc/sqlite
    '';

    # Already tested when this version was the default `sqlite`
    doCheck = false;

    meta = prevAttrs.meta // {
      changelog = "https://www.sqlite.org/releaselog/${
        lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
      }.html";
      identifiers = prevAttrs.meta.identifiers // {
        cpeParts = lib.meta.cpeFullVersionWithVendor "sqlite" finalAttrs.version;
      };
    };
  }
)
