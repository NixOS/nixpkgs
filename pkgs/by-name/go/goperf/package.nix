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
  version = "0-unstable-2026-03-11";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "16a31bc5fbd0f58f2e8e2a496d8e035bdc4a2e06";
    hash = "sha256-be0vWFJUXTPWKapd+rX3Stnzra9LUGNEw+4P+fWzjyk=";
  };

  vendorHash = "sha256-oBSd0D66BGfanCADtrpyIoUit8c+yHk8Nm6o2GmKoZg=";

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
