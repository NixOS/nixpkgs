{
  stdenvNoCC,
  lib,
  fetchzip,
}:

let
  version = "1.7.53.2";
in
stdenvNoCC.mkDerivation {
  pname = "grav";
  inherit version;

  # This is the final version in the version 1 series. If any patch release
  # occurs, it should be manually updated.
  #
  # nixpkgs-update: no auto update
  src = fetchzip {
    url = "https://github.com/getgrav/grav/releases/download/${version}/grav-admin-v${version}.zip";
    hash = "sha256-6cQotHwIwWFR5phFQI9r79jpd+iYA1HpFBbYIzEVBsc=";
  };

  patches = [
    # Disables functionality that attempts to edit files in Nix store. Also adds
    # a block of the self-upgrade command.
    ./01-nix.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/
    runHook postInstall
  '';

  meta = {
    description = "Fast, simple, and flexible, file-based web platform";
    homepage = "https://getgrav.com";
    maintainers = with lib.maintainers; [ rycee ];
    license = lib.licenses.mit;
    knownVulnerabilities = [
      ''
        Grav 1 contains a number of known vulnerabilities, please upgrade to Grav 2.
        This can be done by following the migration instructions[1].

        Note, unfortunately using the automatic migration plugin does not work
        since it cannot write to the Nix store.

        If you use the NixOS module, then add

          service.grav.package = pkgs.grav_2;

        to your configuration to use Grav 2 after you have migrated your site.

        [1]: https://learn.getgrav.org/20/migration/manual-migration.''
    ];
  };
}
