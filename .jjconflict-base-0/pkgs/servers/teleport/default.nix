{
  callPackages,
  lib,
  wasm-bindgen-cli_0_2_95,
  buildGo123Module,
  ...
}@args:
let
  f = args: rec {
    teleport_16 = import ./16 (
      args
      // {
        wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
        buildGoModule = buildGo123Module;
      }
    );
    teleport_17 = import ./17 (
      args
      // {
        wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
        buildGoModule = buildGo123Module;
      }
    );
    teleport = teleport_17;
  };
  # Ensure the following callPackages invocation includes everything 'generic' needs.
  f' = lib.setFunctionArgs f (builtins.functionArgs (import ./generic.nix));
in
callPackages f' (
  builtins.removeAttrs args [
    "callPackages"
    "wasm-bindgen-cli_0_2_95"
    "buildGo123Module"
  ]
)
