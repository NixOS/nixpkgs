# Run:
#   nix-build -A nixosTests.modularServiceVariants
#
# Checks that the service variants registered in ./default.nix keep their file
# attribution. Registering a variant as `import ./<pkg>/<svc>/system.nix`
# instead of `./<pkg>/<svc>/system.nix` yields a bare function, which carries no
# `_file`, so the module system falls back to the location where the
# `deferredModule` was defined and the variant's own file is lost.
#
# `meta.maintainers` makes that observable: it merges to an attribute set that
# maps defining file to maintainers, so its keys are exactly the files that
# contributed to the service.

{
  evalSystem,
  runCommand,
  lib,
  ...
}:

let
  machine = evalSystem (
    { config, ... }:
    {
      system.services.holod.imports = [ config.modularServices.holo-daemon.default ];
      system.services.phpfpm.imports = [ config.modularServices.php.default ];

      # irrelevant stuff
      system.stateVersion = "25.05";
      fileSystems."/" = {
        device = "/test/dummy";
        fsType = "auto";
      };
      boot.loader.grub.enable = false;
    }
  );

  sourcesOf = name: lib.attrNames machine.config.system.services.${name}.meta.maintainers;

  # Both halves of a modular service declare the maintainers of that service:
  # the pure module under `pkgs/`, and the NixOS-specific variant under
  # `nixos/modules/system/service/modular/`.
  expected = {
    holod = [
      "/nixos/modules/system/service/modular/holo-daemon/default/system.nix"
      "/pkgs/by-name/ho/holo-daemon/service.nix"
    ];
    phpfpm = [
      "/nixos/modules/system/service/modular/php/default/system.nix"
      "/pkgs/development/interpreters/php/service.nix"
    ];
  };

  checkService =
    name: suffixes:
    let
      sources = sourcesOf name;
      missing = lib.filter (suffix: !(lib.any (lib.hasSuffix suffix) sources)) suffixes;
      # The attribution `import` would produce instead of the variant's own file.
      fallbacks = lib.filter (lib.hasInfix ", via option ") sources;
    in
    lib.optional (missing != [ ]) ''
      service `${name}' is missing maintainer attribution for:
        ${lib.concatStringsSep "\n    " missing}
    ''
    ++ lib.optional (fallbacks != [ ]) ''
      service `${name}' has fallback attribution, so a variant lost its `_file':
        ${lib.concatStringsSep "\n    " fallbacks}
    '';

  failures = lib.concatLists (lib.mapAttrsToList checkService expected);

  report = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: _: "${name}:\n  ${lib.concatStringsSep "\n  " (sourcesOf name)}") expected
  );
in

lib.throwIf (failures != [ ])
  ''
    Modular service maintainer attribution is wrong:

    ${lib.concatStringsSep "\n" failures}
    Attribution found:
    ${report}
  ''
  runCommand
  "test-modular-service-variants"
  {
    passthru = {
      inherit machine;
    };
  }
  ''
    cat <<'EOF'
    ${report}
    EOF
    echo 🐬👍
    touch $out
  ''
