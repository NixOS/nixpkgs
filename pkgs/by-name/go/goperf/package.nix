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
  version = "0-unstable-2026-02-09";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "b57e4e371b65454dd44026af9d45c69605bc0c3c";
    hash = "sha256-Sz7Fq0H+ikccAfaJirKHLIA+P4ZqMPS3S/Vj7WrGFy4=";
  };

  vendorHash = "sha256-kGF184E+rOWncQsvjk1iCpF26/3Ll/IY9CPEh6vhRBQ=";

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
