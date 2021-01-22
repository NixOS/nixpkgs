{ config, lib, pkgs, ... }:

with lib;
let
  globalConfig = config;
  settingsFormat = {
    type = with lib.types; let
      value = oneOf [ int str ] // {
        description = "INI-like atom (int or string)";
      };
      values = coercedTo value lib.singleton (listOf value) // {
        description = value.description + " or a list of them for duplicate keys";
      };
    in
    attrsOf (values);
    generate = name: values:
      pkgs.writeText name (lib.generators.toKeyValue { listsAsDuplicateKeys = true; } values);
  };
in
{
  options.services.nginx.virtualHosts = mkOption {
    type = types.attrsOf (types.submodule ({ config, ... }:
      let
        cfg = config.cgit;

        # These are the global options for this submodule, but for nicer UX they
        # are inlined into the freeform settings.  Hence they MUST NOT INTERSECT
        # with any settings from cgitrc!
        options = {
          enable = mkEnableOption "cgit";

          location = mkOption {
            default = "/";
            type = types.str;
            description = ''
              Location to serve cgit on.
            '';
          };
        };

        # Remove the global options for serialization into cgitrc
        settings = removeAttrs cfg (attrNames options);
      in
      {
        options.cgit = mkOption {
          type = types.submodule {
            freeformType = settingsFormat.type;
            inherit options;
            config = {
              css = mkDefault "/cgit.css";
              logo = mkDefault "/cgit.png";
              favicon = mkDefault "/favicon.ico";
            };
          };
          default = { };
          example = literalExample ''
            {
              enable = true;
              virtual-root = "/";
              source-filter = "''${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py";
              about-filter = "''${pkgs.cgit}/lib/cgit/filters/about-formatting.sh";
              cache-size = 1000;
              scan-path = "/srv/git";
              include = [
                (builtins.toFile "cgitrc-extra-1" '''
                  # Anything that has to be in a particular order
                ''')
                (builtins.toFile "cgitrc-extra-2" '''
                  # Anything that has to be in a particular order
                ''')
              ];
            }
          '';
          description = ''
            Verbatim contents of the cgit runtime configuration file. Documentation
            (with cgitrc example file) is available in "man cgitrc". Or online:
            http://git.zx2c4.com/cgit/tree/cgitrc.5.txt
          '';
        };

        config = let
          location = removeSuffix "/" cfg.location;
        in mkIf cfg.enable {

          locations."${location}/" = {
            root = "${pkgs.cgit}/cgit/";
            tryFiles = "$uri @cgit";
          };
          locations."~ ^${location}/(cgit.(css|png)|favicon.ico|robots.txt)$" = {
            alias = "${pkgs.cgit}/cgit/$1";
          };
          locations."@cgit" = {
            extraConfig = ''
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_param   CGIT_CONFIG     ${settingsFormat.generate "cgitrc" settings};
              fastcgi_param   SCRIPT_FILENAME ${pkgs.cgit}/cgit/cgit.cgi;
              fastcgi_param   QUERY_STRING    $args;
              fastcgi_param   HTTP_HOST       $server_name;
              fastcgi_pass    unix:${globalConfig.services.fcgiwrap.socketAddress};
            '' + (
              if cfg.location == "/"
              then
                ''
                  fastcgi_param   PATH_INFO   $uri;
                ''
              else
                ''
                  fastcgi_split_path_info  ^(${location}/)(/?.+)$;
                  fastcgi_param  PATH_INFO  $fastcgi_path_info;
                ''
            );
          };
        };

      }));
  };

  config =
    let
      vhosts = config.services.nginx.virtualHosts;
    in
    mkIf (any (name: vhosts.${name}.cgit.enable) (attrNames vhosts)) {
      # make the cgitrc manpage available
      environment.systemPackages = [ pkgs.cgit ];

      services.fcgiwrap.enable = true;
    };

  meta = {
    maintainers = with lib.maintainers; [ afix-space hmenke ];
  };
}
