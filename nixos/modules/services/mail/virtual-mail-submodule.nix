{ config, pkgs, lib, ... }:
with lib;
{
  options = {
    name = mkOption {
      type = types.str;
      example = "postmaster";
      description = "'name' is the part before the @ in the email address";
    };

    password = mkOption {
      type = types.str;
      example = ''
        #{ name = "js"; domain = "lastlog.de"; aliases = [ "joachim@lastlog.de" ]; password = "{SHA256-CRYPT}$5$/CHK3ckfRJloONnq$X/16jK2NPTiZpBZZ1XVpHhPXyxPy1p0QtUNeUFrYav5"; }
        { name = "anton"; domain = "lastlog.de"; aliases = [ "joachim@mail.lastlog.de" ]; password = "{PLAIN}hallo"; }

      '';
      description = ''
        You can generate passwords like this:
          doveadm pw -s sha256-crypt
          Enter new password:
          Retype new password:
          {SHA256-CRYPT}$5$/CHK3ckfRJloONnq$X/16jK2NPTiZpBZZ1XVpHhPXyxPy1p0QtUNeUFrYav5
      '';
    };

    domain = mkOption {
      type = types.str;
      example = "nixcloud.io";
      description = "The domain of your mailservice you want to operate dovecot2 on";
    };

    aliases = mkOption {
      type = types.listOf types.str;
      example = [ "myalias@mydomain.tld" "auchich@mydomain.tld" ];
      description = "A list of email addresses which are all aliases to the virtual mail user in 'name'";
      default = [];
    };

    quota = mkOption {
      type = types.str;
      default = "";
      example = "10G";
      description = "Quota limit for the user in bytes. Supports suffixes b, k, M, G, T and %.";
    };

    catchallFor = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "catchall.mymail.com" "example.mail" ];
      description = "All domains that are catchall domains for which this user receives all emails.";
    };
  };
}
