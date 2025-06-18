let
  lib = import ../../lib;
  inherit (lib)
    isString
    removeAttrs
    ;
in
{
  /**
    Configure the Nixpkgs package set.

    By filling in parameters such as the platform, we obtain a constellation of
    concrete, configured packages, as well as a set of functions that use the
    configured package set.

    # Inputs

    - `hostPlatform`: The platform on which the built packages can run.
    - `buildPlatform`: The platform that is used for building the packages.
    - `overlays`: A list of overlays to apply to the package set.
    - `crossOverlays`: A list of overlays to apply to the target packages only.
    - ...: Other attributes should be among the [Nixpkgs configuration options](https://nixos.org/manual/nixpkgs/stable/#sec-config-options-reference).

    # Outputs

    The output is the package set commonly referred to as `pkgs`.
    Besides many packages, notable attributes include:

    - `_type`: A runtime type tag with value `"pkgs"`
    - `lib`: The standard library
    - `stdenv`: The standard build environment
    - `testers`: Functions that produce derivations that fail to build if something is wrong.
  */
  # TODO: review copied `crossOverlays` doc: isn't it supposed to be "host packages only"? We don't even have "target" in this context.
  configure = parameters@{ hostPlatform, ... }:
    # For now, we convert the parameters to the format the legacy entrypoint expects.
    let
      # Nixpkgs didn't use to classify the platforms as configuration. (??!)
      config = removeAttrs parameters [ "hostPlatform" "buildPlatform" "overlays" "crossOverlays" ];

      # From what I understand, elaboration isn't necessarily idempotent or good.
      # For now we'll just do the minimum.
      elaborateSomewhat = platform: if isString platform then { system = platform; } else platform;

      hostPlatform = elaborateSomewhat parameters.hostPlatform;
      buildPlatform = elaborateSomewhat parameters.buildPlatform;

      isCross = parameters?buildPlatform && ! lib.systems.equals hostPlatform buildPlatform;
    in
      import ../top-level/default.nix {
        localSystem = elaborateSomewhat (if isCross then parameters.buildPlatform else parameters.hostPlatform);
        ${if isCross then "crossSystem" else null} = elaborateSomewhat parameters.hostPlatform;
        overlays = parameters.overlays or [ ];
        crossOverlays = parameters.crossOverlays or [ ];
        inherit config;
      };
}
