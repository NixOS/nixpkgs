{
  lib,
  buildGoModule,
  fetchgit,
  writeShellScript,
  unstableGitUpdater,
  sd,
}:

buildGoModule (finalAttrs: {
  pname = "goperf";
  version = "0-unstable-2026-05-12";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "3cf34090a3db6bb64df2259e30021db7ff5d9595";
    hash = "sha256-2dz8GCzmyS8LkN1zzyCO8cn/NBKmPhIqFRfILc9/lVo=";
  };

  vendorHash = "sha256-H9aP7PGzq5gmFvlYrkrOFfqCSdlpoQkIkTwKMgwr2hs=";

  passthru.updateScript = writeShellScript "update-goperf" ''
    export UPDATE_NIX_ATTR_PATH=goperf
    ${lib.escapeShellArgs (unstableGitUpdater {
      inherit (finalAttrs.src) url;
    })}
    set -x
    oldhash="$(nix-instantiate . --eval --strict -A "goperf.goModules.drvAttrs.outputHash" | cut -d'"' -f2)"
    newhash="$(nix-build -A goperf.goModules --no-out-link 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
    fname="$(nix-instantiate --eval -E 'with import ./. {}; (builtins.unsafeGetAttrPos "version" goperf).file' | cut -d'"' -f2)"
    ${lib.getExe sd} --string-mode "$oldhash" "$newhash" "$fname"
  '';

  meta = {
    description = "Tools and packages for analyzing Go benchmark results";
    homepage = "https://cs.opensource.google/go/x/perf";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pbsds ];
  };
})
