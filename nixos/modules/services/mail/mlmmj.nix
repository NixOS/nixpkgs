{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  concatMapLines = f: l: lib.concatStringsSep "\n" (map f l);

  cfg = config.services.mlmmj;
  stateDir = "/var/lib/mlmmj";
  spoolDir = "/var/spool/mlmmj";
  listDir = domain: list: "${spoolDir}/${domain}/${list}";
  listCtl = domain: list: "${listDir domain list}/control";
  transport = domain: list: "${domain}--${list}@local.list.mlmmj mlmmj:${domain}/${list}";
  virtual = domain: list: "${list}@${domain} ${domain}--${list}@local.list.mlmmj";
  alias = domain: list: "${list}: \"|${pkgs.mlmmj}/bin/mlmmj-receive -L ${listDir domain list}/\"";
  subjectPrefix = list: "[${list}]";
  listAddress = domain: list: "${list}@${domain}";
  customHeaders = domain: list: [
    "List-Id: ${list}"
    "Reply-To: ${list}@${domain}"
    "List-Post: <mailto:${list}@${domain}>"
    "List-Help: <mailto:${list}+help@${domain}>"
    "List-Subscribe: <mailto:${list}+subscribe@${domain}>"
    "List-Unsubscribe: <mailto:${list}+unsubscribe@${domain}>"
  ];
  footer = domain: list: "To unsubscribe send a mail to ${list}+unsubscribe@${domain}";
  createList =
    d: l:
    let
      ctlDir = listCtl d l;
    in
    ''
      for DIR in incoming queue queue/discarded archive text subconf unsubconf \
                 bounce control moderation subscribers.d digesters.d requeue \
                 nomailsubs.d
      do
             mkdir -p '${listDir d l}'/"$DIR"
      done
      ${pkgs.coreutils}/bin/mkdir -p ${ctlDir}
      echo ${listAddress d l} > '${ctlDir}/listaddress'
      [ ! -e ${ctlDir}/customheaders ] && \
          echo "${lib.concatStringsSep "\n" (customHeaders d l)}" > '${ctlDir}/customheaders'
      [ ! -e ${ctlDir}/footer ] && \
          echo ${footer d l} > '${ctlDir}/footer'
      [ ! -e ${ctlDir}/prefix ] && \
          echo ${subjectPrefix l} > '${ctlDir}/prefix'
    '';
in

{

  ###### interface

  options = {

    services.mlmmj = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable mlmmj";
      };

      user = mkOption {
        type = types.str;
        default = "mlmmj";
        description = "mailinglist local user";
      };

      group = mkOption {
        type = types.str;
        default = "mlmmj";
        description = "mailinglist local group";
      };

      listDomain = mkOption {
        type = types.str;
        default = "localhost";
        description = "Set the mailing list domain";
      };

      mailLists = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "The collection of hosted maillists";
      };

      maintInterval = mkOption {
        type = types.str;
        default = "20min";
        description = ''
          Time interval between mlmmj-maintd runs, see
          {manpage}`systemd.time(7)` for format information.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    users.users.${cfg.user} = {
      description = "mlmmj user";
      home = stateDir;
      createHome = true;
      uid = config.ids.uids.mlmmj;
      group = cfg.group;
      useDefaultShell = true;
    };

    users.groups.${cfg.group} = {
      gid = config.ids.gids.mlmmj;
    };

    services.postfix = {
      enable = true;
      recipientDelimiter = "+";
      masterConfig.mlmmj = {
        type = "unix";
        private = true;
        privileged = true;
        chroot = false;
        wakeup = 0;
        command = "pipe";
        args = [
          "flags=ORhu"
          "user=mlmmj"
          "argv=${pkgs.mlmmj}/bin/mlmmj-receive"
          "-F"
          "-L"
          "${spoolDir}/$nexthop"
        ];
      };

      extraAliases = concatMapLines (alias cfg.listDomain) cfg.mailLists;

      extraConfig = "propagate_unmatched_extensions = virtual";

      virtual = concatMapLines (virtual cfg.listDomain) cfg.mailLists;
      transport = concatMapLines (transport cfg.listDomain) cfg.mailLists;
    };

    environment.systemPackages = [ pkgs.mlmmj ];

    systemd.tmpfiles.settings."10-mlmmj" = {
      ${stateDir}.d = { };
      "${spoolDir}/${cfg.listDomain}".d = { };
      ${spoolDir}.Z = {
        inherit (cfg) user group;
      };
    };

    systemd.services.mlmmj-maintd = {
      description = "mlmmj maintenance daemon";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.mlmmj}/bin/mlmmj-maintd -F -d ${spoolDir}/${cfg.listDomain}";
      };
      preStart = ''
        ${concatMapLines (createList cfg.listDomain) cfg.mailLists}
        ${pkgs.postfix}/bin/postmap /etc/postfix/virtual
        ${pkgs.postfix}/bin/postmap /etc/postfix/transport
      '';
    };

    systemd.timers.mlmmj-maintd = {
      description = "mlmmj maintenance timer";
      timerConfig.OnUnitActiveSec = cfg.maintInterval;
      wantedBy = [ "timers.target" ];
    };
  };

}
