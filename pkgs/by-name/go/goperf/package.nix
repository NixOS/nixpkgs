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
  version = "0-unstable-2025-04-07";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "71ba5bc8ccce8a755de82e9bad6ca4e4d7b590d2";
    hash = "sha256-xY9Z502YUUePqoocBWWPxD/TLFQtYq3TLyj3Izp8n9A=";
  };

  vendorHash = "sha256-BYfn9ip8QCS+spYR51eS6SysYlZtBZf7GhuFZVh3Kb8=";

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
