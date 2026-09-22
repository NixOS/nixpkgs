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
  version = "0-unstable-2026-09-08";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "22c9c6c9d4da6248aedbc79f02ecedcd59f8f5f2";
    hash = "sha256-RSiI5I92l9bMWxTbHNKhcti4OKj8kD9yFxeHaWQJiFU=";
  };

  vendorHash = "sha256-9y6O/R2fOPYAGjlIZ2lcO1TNiZPj6My3EoPRiiFZu3U=";

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
