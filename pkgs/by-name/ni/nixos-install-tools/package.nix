{
  buildEnv,
  lib,
  nixos,
  # TODO: replace indirect self-reference by proper self-reference
  #       https://github.com/NixOS/nixpkgs/pull/119942
  nixos-install-tools,
  nixos-install,
  nixos-enter,
  nixosTests,
  binlore,
}:
let
  inherit (nixos { }) config;
  version = config.system.nixos.version;
in
(buildEnv {
  name = "nixos-install-tools-${version}";
  paths = lib.attrValues {
    # See nixos/modules/installer/tools/tools.nix
    inherit (config.system.build) nixos-generate-config;
    inherit nixos-install nixos-enter;
    inherit (config.system.build.manual) nixos-configuration-reference-manpage;
  };

  extraOutputsToInstall = [ "man" ];

  meta = {
    description = "Essential commands from the NixOS installer as a package";
    longDescription = ''
      With this package, you get the commands like nixos-generate-config and
      nixos-install that you would otherwise only find on a NixOS system, such
      as an installer image.

      This way, you can install NixOS using a machine that only has Nix.
    '';
    license = lib.licenses.mit;
    homepage = "https://nixos.org";
    platforms = lib.platforms.linux;
  };

  passthru.tests = lib.recurseIntoAttrs nixosTests.installer;

  # no documented flags show signs of exec; skim of source suggests
  # it's just --help execing man
  passthru.binlore.out = binlore.synthesize nixos-install-tools ''
    execer cannot bin/nixos-generate-config
  '';
}).overrideAttrs
  {
    inherit version;
    pname = "nixos-install-tools";
  }
