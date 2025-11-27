{
  buildFHSEnv,
  callPackage,
}:
let
  unwrapped = callPackage ./unwrapped.nix { };
in
buildFHSEnv {
  pname = "acli";
  inherit (unwrapped) version;

  targetPkgs =
    p: with p; [
      unwrapped

      # For plugins
      zlib # rovodev
    ];

  runScript = "acli";

  passthru = {
    inherit unwrapped;
  };

  inherit (unwrapped) meta;
}
