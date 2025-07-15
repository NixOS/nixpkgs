{
  system ? builtins.currentSystem,
  pkgs ? (import ../. { inherit system; }).pkgs,
}:

pkgs.callPackage (
  {
    mkShell,
    importNpmLock,
    nodejs,
  }:
  mkShell {
    packages = [
      importNpmLock.hooks.linkNodeModulesHook
      nodejs
    ];

    npmDeps = importNpmLock.buildNodeModules {
      npmRoot = ./.;
      inherit nodejs;
    };
  }
) { }
