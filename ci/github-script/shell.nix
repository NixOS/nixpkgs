{
  system ? builtins.currentSystem,
  pkgs ? (import ../. { inherit system; }).pkgs,
}:

pkgs.callPackage (
  {
    gh,
    importNpmLock,
    mkShell,
    nodejs_24,
  }:
  mkShell {
    packages = [
      gh
      importNpmLock.hooks.linkNodeModulesHook
      nodejs_24
      (pkgs.callPackage ./. { }).passthru.driver
    ];

    npmDeps = importNpmLock.buildNodeModules {
      npmRoot = ./.;
      nodejs = nodejs_24;
    };
  }
) { }
