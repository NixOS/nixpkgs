# This module provides configuration for the OATH PAM modules.
{ lib, ... }:
{
  options = {

    security.pam.oath = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable the OATH (one-time password) PAM module.
        '';
      };

      digits = lib.mkOption {
        type = lib.types.enum [
          6
          7
          8
        ];
        default = 6;
        description = ''
          Specify the lib.length of the one-time password in number of
          digits.
        '';
      };

      window = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = ''
          Specify the number of one-time passwords to check in order
          to accommodate for situations where the system and the
          client are slightly out of sync (iteration for HOTP or time
          steps for TOTP).
        '';
      };

      usersFile = lib.mkOption {
        type = lib.types.path;
        default = "/etc/users.oath";
        description = ''
          Set the path to file where the user's credentials are
          stored. This file must not be world readable!
        '';
      };
    };

  };
}
