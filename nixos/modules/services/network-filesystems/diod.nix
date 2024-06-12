{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.diod;

  diodBool = b: if b then "1" else "0";

  diodConfig = pkgs.writeText "diod.conf" ''
    allsquash = ${diodBool cfg.allsquash}
    auth_required = ${diodBool cfg.authRequired}
    exportall = ${diodBool cfg.exportall}
    exportopts = "${concatStringsSep "," cfg.exportopts}"
    exports = { ${concatStringsSep ", " (map (s: ''"${s}"'' ) cfg.exports)} }
    listen = { ${concatStringsSep ", " (map (s: ''"${s}"'' ) cfg.listen)} }
    logdest = "${cfg.logdest}"
    nwthreads = ${toString cfg.nwthreads}
    squashuser = "${cfg.squashuser}"
    statfs_passthru = ${diodBool cfg.statfsPassthru}
    userdb = ${diodBool cfg.userdb}
    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.diod = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the diod 9P file server.";
      };

      listen = mkOption {
        type = types.listOf types.str;
        default = [ "0.0.0.0:564" ];
        description = ''
          [ "IP:PORT" [,"IP:PORT",...] ]
          List the interfaces and ports that diod should listen on.
        '';
      };

      exports = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List the file systems that clients will be allowed to mount. All paths should
          be fully qualified. The exports table can include two types of element:
          a string element (as above),
          or an alternate table element form { path="/path", opts="ro" }.
          In the alternate form, the (optional) opts attribute is a comma-separated list
          of export options. The two table element forms can be mixed in the exports
          table. Note that although diod will not traverse file system boundaries for a
          given mount due to inode uniqueness constraints, subdirectories of a file
          system can be separately exported.
        '';
      };

      exportall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Export all file systems listed in /proc/mounts. If new file systems are mounted
          after diod has started, they will become immediately mountable. If there is a
          duplicate entry for a file system in the exports list, any options listed in
          the exports entry will apply.
        '';
      };

      exportopts = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Establish a default set of export options. These are overridden, not appended
          to, by opts attributes in an "exports" entry.
        '';
      };

      nwthreads = mkOption {
        type = types.int;
        default = 16;
        description = ''
          Sets the (fixed) number of worker threads created to handle 9P
          requests for a unique aname.
        '';
      };

      authRequired = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allow clients to connect without authentication, i.e. without a valid MUNGE credential.
        '';
      };

      userdb = mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option disables password/group lookups. It allows any uid to attach and
          assumes gid=uid, and supplementary groups contain only the primary gid.
        '';
      };

      allsquash = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Remap all users to "nobody". The attaching user need not be present in the
          password file.
        '';
      };

      squashuser = mkOption {
        type = types.str;
        default = "nobody";
        description = ''
          Change the squash user. The squash user must be present in the password file.
        '';
      };

      logdest = mkOption {
        type = types.str;
        default = "syslog:daemon:err";
        description = ''
          Set the destination for logging.
          The value has the form of "syslog:facility:level" or "filename".
        '';
      };


      statfsPassthru = mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option configures statfs to return the host file system's type
          rather than V9FS_MAGIC.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration options for diod.conf.";
      };
    };
  };

  config = mkIf config.services.diod.enable {
    environment.systemPackages = [ pkgs.diod ];

    systemd.services.diod = {
      description = "diod 9P file server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.diod}/sbin/diod -f -c ${diodConfig}";
      };
    };
  };
}
