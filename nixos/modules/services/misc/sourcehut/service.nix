{ config, pkgs, lib }:
serviceCfg: serviceDrv: iniKey: attrs:

let
  cfg = config.services.sourcehut;
  cfgIni = cfg.settings."${iniKey}";
  pgSuperUser = config.services.postgresql.superUser;

  setupDB = pkgs.writeScript "${serviceDrv.pname}-gen-db" ''
    #! ${cfg.python}/bin/python
    from ${serviceDrv.pname}.app import db
    db.create()
  '';
in with serviceCfg; with lib; recursiveUpdate {
  environment.HOME = statePath;
  path = [ config.services.postgresql.package ] ++ (attrs.path or []);
  restartTriggers = [ config.environment.etc."sr.ht/config.ini".source ];
  serviceConfig = {
    Type = "simple";
    User = user;
    Group = user;
    Restart = "always";
    WorkingDirectory = statePath;
  };

  preStart = ''
    if ! test -e ${statePath}/db; then
      # Setup the initial database
      ${setupDB}

      # Set the initial state of the database for future database upgrades
      if test -e ${cfg.python}/bin/${serviceDrv.pname}-migrate; then
        # Run alembic stamp head once to tell alembic the schema is up-to-date
        ${cfg.python}/bin/${serviceDrv.pname}-migrate stamp head
      fi

      printf "%s" "${serviceDrv.version}" > ${statePath}/db
    fi

    # Update copy of each users' profile to the latest
    # See https://lists.sr.ht/~sircmpwn/sr.ht-admins/<20190302181207.GA13778%40cirno.my.domain>
    if ! test -e ${statePath}/webhook; then
      # Update ${iniKey}'s users' profile copy to the latest
      ${cfg.python}/bin/srht-update-profiles ${iniKey}

      touch ${statePath}/webhook
    fi

    ${optionalString (builtins.hasAttr "migrate-on-upgrade" cfgIni && cfgIni.migrate-on-upgrade == "yes") ''
      if [ "$(cat ${statePath}/db)" != "${serviceDrv.version}" ]; then
        # Manage schema migrations using alembic
        ${cfg.python}/bin/${serviceDrv.pname}-migrate -a upgrade head

        # Mark down current package version
        printf "%s" "${serviceDrv.version}" > ${statePath}/db
      fi
    ''}

    ${attrs.preStart or ""}
  '';
} (builtins.removeAttrs attrs [ "path" "preStart" ])
