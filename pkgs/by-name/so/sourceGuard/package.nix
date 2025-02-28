# Docs in doc/hooks/sourceGuard.section.md
# See https://nixos.org/manual/nixpkgs/unstable/#setup-hook-sourceGuard
{
  callPackages,
  lib,
  makeSetupHook',
}:
makeSetupHook' {
  name = "source-guard";
  script = ./source-guard.bash;
  useSourceGuard = false; # Avoid self-reference
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Ensure files are sourced at most once and are build-time dependencies";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}
