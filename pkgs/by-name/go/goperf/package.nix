{
  lib,
  buildGoModule,
  fetchgit,
  writeShellScript,
  unstableGitUpdater,
  sd,
}:

buildGoModule rec {
  pname = "goperf";
  version = "0-unstable-2025-08-13";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "2f7363a06fe1e84314f47158b693ef982b0c2255";
    hash = "sha256-Qn8kIIPJp+40FEUzkY9JvEC4bailFdmYLg95skHwgIw=";
  };

  vendorHash = "sha256-tJ5UcYkjPN4JKteBwednG1ZFYIl4lxvEq6qygpR4jv0=";

  passthru.updateScript = writeShellScript "update-goperf" ''
    export UPDATE_NIX_ATTR_PATH=goperf
    ${lib.escapeShellArgs (unstableGitUpdater {
      inherit (src) url;
    })}
    set -x
    oldhash="$(nix-instantiate . --eval --strict -A "goperf.goModules.drvAttrs.outputHash" | cut -d'"' -f2)"
    newhash="$(nix-build -A goperf.goModules --no-out-link 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
    fname="$(nix-instantiate --eval -E 'with import ./. {}; (builtins.unsafeGetAttrPos "version" goperf).file' | cut -d'"' -f2)"
    ${lib.getExe sd} --string-mode "$oldhash" "$newhash" "$fname"
  '';

  meta = with lib; {
    description = "Tools and packages for analyzing Go benchmark results";
    homepage = "https://cs.opensource.google/go/x/perf";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ pbsds ];
  };
}
