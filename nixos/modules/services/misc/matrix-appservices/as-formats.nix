{ systemConfig, asConfig, lib, pkgs, ... }:

with lib;
let
  inherit (systemConfig.services.matrix-appservices)
    homeserverURL
    homeserverDomain;
  package = asConfig.package;
  pname = getName package;
  command = "${package}/bin/${pname}";

  mautrix = {
    registerScript = ''
      ${command} --generate-registration \
        --config=$SETTINGS_FILE \
        --registration=$REGISTRATION_FILE
    '';

    # mautrix stores the registration tokens in the config file
    startupScript = ''
      mv $SETTINGS_FILE $SETTINGS_FILE.tmp
      yq -s '.[0].appservice.as_token = .[1].as_token
        | .[0].appservice.hs_token = .[1].hs_token
        | .[0]' $SETTINGS_FILE.tmp $REGISTRATION_FILE \
        > $SETTINGS_FILE

      ${command} --config=$SETTINGS_FILE \
        --registration=$REGISTRATION_FILE
    '';

    settings = {
      homeserver = {
        address = homeserverURL;
        domain = homeserverDomain;
      };

      appservice.state_store_path = "$DIR/mx-state.json";

      bridge.permissions = {
        ${homeserverDomain} = "user";
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
    registerScript = ''
      url=$(cat $SETTINGS_FILE | yq .appserviceUrl)
      if [ -z $url ]; then
        url="http://localhost:$(cat $SETTINGS_FILE | yq .appservicePort)"
      fi
      ${command} --generate-registration \
        --config=$SETTINGS_FILE --url="$url" \
        --file=$REGISTRATION_FILE
    '';

    startupScript = ''
      port=$(cat $SETTINGS_FILE | yq .appservicePort)
      ${command} --config=$SETTINGS_FILE --url="$url" \
        --port=$port --file=$REGISTRATION_FILE
    '';

    description = ''
      For bridges based on the matrix-appservice-bridge library. The settings for these
      bridges are NOT configured automatically, because of the various differences
      between them. And you must set appservicePort(and optionally apserviceURL)
      in the settings to pass to the bridge - these settings are not usually part of the config file.
    '';
  };

  mx-puppet = {
    preStart = ''
      mv $SETTINGS_FILE $SETTINGS_FILE.tmp
      yq -s '.[0] * .[1]' \
        ${package.src}/sample.config.yaml $SETTINGS_FILE.tmp > $SETTINGS_FILE
    '';

    registerScript = ''
      ${command} \
        --register \
        --config=$SETTINGS_FILE \
        --registration-file=$REGISTRATION_FILE
    '';

    startupScript = ''
      ${command} \
        --config=$SETTINGS_FILE \
        --registration-file=$REGISTRATION_FILE
    '';

    settings = {
      bridge = {
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
    inherit (mautrix) registerScript startupScript;

    preStart = ''
      mv $SETTINGS_FILE $SETTINGS_FILE.tmp
      yq -s '.[0] * .[1]' \
        ${package.src}/example-config.yaml $SETTINGS_FILE.tmp > $SETTINGS_FILE
    '';

    settings = recursiveUpdate mautrix.settings {
      appservice.database = {
        type = "sqlite3";
        uri = "$DIR/database.db";
      };
      bridge.permissions = {
        # override defaults
        "@admin:example.com" = "relaybot";
        "example.com" = "relaybot";
      };
    };

    description = ''
      The settings are configured to use a sqlite database. The startupScript will
      create a new config file on every run to set the tokens, because mautrix
      requires them to be in the config file.
    '';
  };

  mautrix-python = {
    inherit (mautrix) registerScript;

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
