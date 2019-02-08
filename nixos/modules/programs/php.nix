{ config, pkgs, lib, ... }:

let

  cfg = config.programs.php;

  phpIni = pkgs.runCommand "php.ini" {
    inherit (cfg) phpPackage phpOptions;
    nixDefaults =
      ''
        ; Needed for PHP's mail() function.
        sendmail_path = sendmail -t -i
      '' + lib.optionalString (!isNull config.time.timeZone) ''
        ; Apparently PHP doesn't use $TZ.
        date.timezone = "${config.time.timeZone}"
      '';
    passAsFile = [ "nixDefaults" "phpOptions" ];
  } ''
    cat $phpPackage/etc/php.ini $nixDefaultsPath $phpOptionsPath > $out
  '';

  phpWrapper = pkgs.symlinkJoin {
    name = "php";
    paths = [ cfg.phpPackage ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/php --set PHPRC ${phpIni}
    '';
  };

in
{

  # interface

  options = {

    programs.php = {

      enable = lib.mkEnableOption "Enable PHP for the command line.";

      phpPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.php;
        defaultText = "pkgs.php";
        description = "Overridable attribute of the PHP package to use.";
      };

      phpOptions = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          date.timezone = "CET";
        '';
        description = "Options appended to the PHP configuration file <filename>php.ini</filename>.";
      };

    };

  };

  # implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ phpWrapper ];

  };

}
