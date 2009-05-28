{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {
      guestUsers = {
        enable = mkOption {
	  default = false;
	  description = "
	    Whether to enable automatic addition of users with empty passwords
	  ";
	};
	users = mkOption {
	  default = ["guest"];
	  description = "
	    List of usernames to add
	  ";
	};
	includeRoot = mkOption {
	  default = false;
	  description = "
	    LEAVE THAT ALONE; whether to reset root password
	  ";
	};
	extraGroups = mkOption {
	  default = ["audio"];
	  description = "
	    Extra groups to grant
	  ";
	};
      };
    };
  };
  inherit (pkgs.lib) concatStringsSep optional optionalString;

  inherit (config.services.guestUsers) enable users includeRoot extraGroups;

  userEntry = user:
  {
    name = user;
    description = "NixOS guest user";
    home = "/home/${user}";
    createHome = true;
    group = "users";
    extraGroups = extraGroups;
    shell = "/bin/sh";
  };

  nameString = (concatStringsSep " " users) + optionalString includeRoot " root";

in 

{
  require = options;

  system.activationScripts = pkgs.lib.fullDepEntry
    ''
      for i in ${nameString}; do
          echo | ${pkgs.pwdutils}/bin/passwd --stdin $i
      done
    '' ["defaultPath" "users" "groups"];

  services.mingetty.helpLine = optionalString enable "\nThese users have empty passwords: ${nameString}";
  
  users.extraUsers = map userEntry users;
}
