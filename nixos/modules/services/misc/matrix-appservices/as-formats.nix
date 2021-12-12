{ name, systemConfig, asConfig, lib, pkgs, ... }:

with lib;
let
  inherit (systemConfig.services.matrix-appservices)
    homeserverURL
    homeserverDomain;
  package = asConfig.package;
  pname = getName package;
  command = "${package}/bin/${pname}";

  mautrix = {
    startupScript = ''
      ${command} --config=$SETTINGS_FILE \
        --registration=$REGISTRATION_FILE
    '';

    settings = {
      homeserver = {
        address = homeserverURL;
        domain = homeserverDomain;
      };

      appservice = with asConfig; {
        address = "http://${host}:${toString port}";

        hostname = host;
        inherit port;

        state_store_path = "$DIR/mx-state.json";
        # mautrix stores the registration tokens in the config file
        as_token = "$AS_TOKEN";
        hs_token = "$HS_TOKEN";
      };

      bridge = {
        username_template = "${name}_{userid}";
        permissions = {
          ${homeserverDomain} = "user";
        };
      };
    };
  };

in
{
  other = {
    description = ''
      No defaults will be set.
    '';
  };

  matrix-appservice = {
    startupScript = ''
      ${command} \
        --config=$SETTINGS_FILE \
        --port=$(echo ${asConfig.listenAddress} | sed 's/.*://') \
        --file=$REGISTRATION_FILE
    '';

    description = ''
      For bridges based on the matrix-appservice-bridge library. The settings for these
      bridges are NOT configured automatically, because of the various differences
      between them.
    '';
  };

  mx-puppet = {
    startupScript = ''
      ${command} \
        --config=$SETTINGS_FILE \
        --registration-file=$REGISTRATION_FILE
    '';

    registrationData =
      let
        # mx-puppet virtual users are always created based on the package name
        botName = removePrefix "mx-puppet-" pname;
      in
      {
        id = "${botName}-puppet";
        sender_localpart = "_${botName}puppet_bot";
        protocols = [ ];
        namespaces = {
          rooms = [ ];
          users = [
            {
              regex = "@_${botName}puppet_.*:${homeserverDomain}";
              exclusive = true;
            }
          ];
          aliases = [
            {
              regex = "#_${botName}puppet_.*:${homeserverDomain}";
              exclusive = true;
            }
          ];
        };
      };

    settings = {
      bridge = {
        inherit (asConfig) port;
        bindAddress = asConfig.host;
        domain = homeserverDomain;
        homeserverUrl = homeserverURL;
      };
      database.filename = "$DIR/database.db";
      provisioning.whitelist = [ "@.*:${homeserverDomain}" ];
      relay.whitelist = [ "@.*:${homeserverDomain}" ];
      selfService.whitelist = [ "@.*:${homeserverDomain}" ];
      logging = {
        lineDateFormat = "";
        files = [ ];
      };
    };

    serviceConfig.WorkingDirectory =
      "${package}/lib/node_modules/${pname}";

    description = ''
      For bridges based on the mx-puppet-bridge library. The settings will be
      configured to use a sqlite database. Make sure to override database.filename,
      if you plan to use another database.
    '';

  };

  mautrix-go = {
    inherit (mautrix) startupScript;

    settings = recursiveUpdate mautrix.settings {
      bridge.username_template = "${name}_{{.}}";
      appservice.database = {
        type = "sqlite3";
        uri = "$DIR/database.db";
      };
    };

    description = ''
      The settings are configured to use a sqlite database. The startupScript will
      create a new config file on every run to set the tokens, because mautrix
      requires them to be in the config file.
    '';
  };

  mautrix-python = {
    settings = recursiveUpdate mautrix.settings {
      appservice.database = "sqlite:///$DIR/database.db";
    };

    startupScript = optionalString (package ? alembic)
      "${package.alembic}/bin/alembic -x config=$SETTINGS_FILE upgrade head\n"
    + mautrix.startupScript;
    description = ''
      Same properties as mautrix-go. This will also upgrade the database on every run
    '';
  };

}
