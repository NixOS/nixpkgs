{ config, lib, name, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {

    proxyPass = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "http://www.example.org/";
      description = lib.mdDoc ''
        Sets up a simple reverse proxy as described by <https://httpd.apache.org/docs/2.4/howto/reverse_proxy.html#simple>.
      '';
    };

    index = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "index.php index.html";
      description = lib.mdDoc ''
        Adds DirectoryIndex directive. See <https://httpd.apache.org/docs/2.4/mod/mod_dir.html#directoryindex>.
      '';
    };

    alias = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/your/alias/directory";
      description = lib.mdDoc ''
        Alias directory for requests. See <https://httpd.apache.org/docs/2.4/mod/mod_alias.html#alias>.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        These lines go to the end of the location verbatim.
      '';
    };

    priority = mkOption {
      type = types.int;
      default = 1000;
      description = lib.mdDoc ''
        Order of this location block in relation to the others in the vhost.
        The semantics are the same as with `lib.mkOrder`. Smaller values have
        a greater priority.
      '';
    };

  };
}
