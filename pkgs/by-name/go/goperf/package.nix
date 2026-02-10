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
  version = "0-unstable-2026-01-12";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "5abaabe9f1bd66f90f8a5c17cb71183db0d81820";
    hash = "sha256-76fYE6cr2L9nTW9QA79GtHmuDy3bM85glVcy4gN94qk=";
  };

  vendorHash = "sha256-bBL9YUwhnUWBnEykFoSoc7d8wOnEtfiF0aW5cqYzm5U=";

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
