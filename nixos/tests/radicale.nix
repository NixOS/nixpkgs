let
  port = 5232;
  radicaleOverlay = self: super: {
    radicale = super.radicale.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = with self.pythonPackages;
        (oldAttrs.propagatedBuildInputs or []) ++ [
          passlib
        ];
    });
  };
  common = { config, pkgs, ...}: {
    services.radicale = {
      enable = true;
      config = let home = config.users.extraUsers.radicale.home; in ''
        [server]
        hosts = 127.0.0.1:${builtins.toString port}
        daemon = False
        [encoding]
        [well-known]
        [auth]
        type = htpasswd
        htpasswd_filename = /etc/radicale/htpasswd
        htpasswd_encryption = bcrypt
        [git]
        [rights]
        [storage]
        type = filesystem
        filesystem_folder = ${home}/collections
        [logging]
        [headers]
      '';
    };
    # WARNING: DON'T DO THIS IN PRODUCTION!
    # This puts secrets (albeit hashed) directly into the Nix store for ease of testing.
    environment.etc."radicale/htpasswd".source = with pkgs; let
      py = python.withPackages(ps: with ps; [ passlib ]);
    in runCommand "htpasswd" {} ''
        ${py}/bin/python -c "
from passlib.apache import HtpasswdFile
ht = HtpasswdFile(
    '$out',
    new=True,
    default_scheme='bcrypt'
)
ht.set_password('someuser', 'really_secret_password')
ht.save()
"
    '';
  };

in import ./make-test.nix ({ lib, ... }: {
  name = "radicale";
  meta.maintainers = with lib.maintainers; [ aneeshusa ];

  # Test radicale with bcrypt-based htpasswd authentication
  nodes = {
    py2 = { config, pkgs, ... }@args: (common args) // {
      nixpkgs.overlays = [
        radicaleOverlay
      ];
    };
    py3 = { config, pkgs, ... }@args: (common args) // {
      nixpkgs.overlays = [
        (self: super: {
          python = self.python3;
          pythonPackages = self.python3.pkgs;
        })
        radicaleOverlay
      ];
    };
  };

  testScript = ''
    for my $machine ($py2, $py3) {
      $machine->waitForUnit('radicale.service');
      $machine->waitForOpenPort(${builtins.toString port});
      $machine->succeed('curl -s http://someuser:really_secret_password@127.0.0.1:${builtins.toString port}/someuser/calendar.ics/');
    }
  '';
})
