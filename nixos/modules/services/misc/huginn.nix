{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.huginn;

  ruby = cfg.packages.huginn.ruby;

  bundler = pkgs.bundler;

  gemHome = "${cfg.packages.huginn.env}/${ruby.gemPath}";

  unicornFile = cfg.unicornConfig;

  procFile = cfg.procFileConfig;

  envFile = cfg.envFileConfig;

  serve_static_files = (if cfg.enableUnicorn then false else true);

  huginnEnv = {
    LD_LIBRARY_PATH = "${pkgs.curl.out}/lib:${pkgs.postgresql}/lib";
    GEM_HOME = gemHome;
    BUNDLE_GEMFILE = "${cfg.packages.huginn}/share/huginn/Gemfile";
    UNICORN_PATH = "${cfg.statePath}/";
    HUGINN_PATH = "${cfg.packages.huginn}/share/huginn/";
    HUGINN_STATE_PATH = "${cfg.statePath}";
    HUGINN_UPLOADS_PATH = "${cfg.statePath}/uploads";
    HUGINN_LOG_PATH = "${cfg.statePath}/log/huginn.log";
    RAILS_ENV = "production";
    #if variable exists at all its considered true.
    RAILS_SERVE_STATIC_FILES = (if serve_static_files then "true" else "");
    # I set this by hand because I wanted to maintain sessions between restarts.
    #I totally know what I am doing security wise.
    APP_SECRET_TOKEN= cfg.appSecretToken;
    DOMAIN=(if !cfg.enableUnicorn then cfg.host else "");
    PORT=(if !cfg.enableUnicorn then toString cfg.port else "");
    DATABASE_HOST=cfg.databaseHost;
    DATABASE_PORT=(toString cfg.databasePort);
    DATABASE_ADAPTER="postgresql";
    DATABASE_ENCODING="utf8";
    DATABASE_RECONNECT="true";
    DATABASE_NAME= cfg.databaseName;
    DATABASE_POOL= (toString cfg.databasePool);
    DATABASE_USERNAME=cfg.databaseUser;
    DATABASE_PASSWORD=cfg.databasePassword;
    # Optionally set an asset host
    ASSET_HOST=cfg.assetHost;
    FORCE_SSL= (if cfg.forceSSL then "true" else "false");
    INVITATION_CODE=cfg.registration.invitationCode;
    SKIP_INVITATION_CODE=(if cfg.registration.skipInvitation then "true" else "false");
    REQUIRE_CONFIRMED_EMAIL=(if cfg.registration.requireConfirmation then "true" else "false");
    ALLOW_UNCONFIRMED_ACCESS_FOR=cfg.registration.unconfirmedDuration;
    CONFIRM_WITHIN=cfg.registration.confirmWithin;
    MIN_PASSWORD_LENGTH=(toString cfg.registration.minPassword);
    RESET_PASSWORD_WITHIN=cfg.registration.resetWithin;
    LOCK_STRATEGY=(if cfg.registration.enableUserLockout then  "failed_attempts" else "none");
    MAX_FAILED_LOGIN_ATTEMPTS=(toString cfg.registration.maxFailedLogin);
    UNLOCK_STRATEGY=cfg.registration.unlockStrategy;
    UNLOCK_AFTER=cfg.registration.unlockAfter;
    REMEMBER_FOR=cfg.registration.sessionDuration;
    IMPORT_DEFAULT_SCENARIO_FOR_ALL_USERS=(if cfg.registration.enableScenarioDefaults then "true" else "false");
    DEFAULT_SCENARIO_FILE=cfg.registration.defaultScenario;
    SMTP_DOMAIN=cfg.smtp.domain;
    SMTP_USER_NAME=cfg.smtp.user;
    SMTP_PASSWORD=cfg.smtp.password;
    SMTP_SERVER=cfg.smtp.server;
    SMTP_PORT=(toString cfg.smtp.port);
    SMTP_AUTHENTICATION=cfg.smtp.authenticationType;
    SMTP_ENABLE_STARTTLS_AUTO=(if cfg.smtp.enableTLS then "true" else "false");
    EMAIL_FROM_ADDRESS=cfg.smtp.fromAddress;
    AGENT_LOG_LENGTH=(toString cfg.agentLogLength);
    TWITTER_OAUTH_KEY=cfg.oauth.twitterKey;
    TWITTER_OAUTH_SECRET=cfg.oauth.twitterSecret;
    THIRTY_SEVEN_SIGNALS_OAUTH_KEY=cfg.oauth.thirtySevenSignalsKey;
    THIRTY_SEVEN_SIGNALS_OAUTH_SECRET=cfg.oauth.thirtySevenSignalsSecret;
    GITHUB_OAUTH_KEY=cfg.oauth.gitHubKey;
    GITHUB_OAUTH_SECRET=cfg.oauth.gitHubSecret;
    TUMBLR_OAUTH_KEY=cfg.oauth.tumblrKey;
    TUMBLR_OAUTH_SECRET=cfg.oauth.tumblrSecret;
    DROPBOX_OAUTH_KEY=cfg.oauth.dropBoxKey;
    DROPBOX_OAUTH_SECRET=cfg.oauth.dropBoxSecret;
    WUNDERLIST_OAUTH_KEY=cfg.oauth.wunderlistKey;
    WUNDERLIST_OAUTH_SECRET=cfg.oauth.wunderlistSecret;
    EVERNOTE_OAUTH_KEY=cfg.oauth.everNoteKey;
    EVERNOTE_OAUTH_SECRET=cfg.oauth.everNoteSecret;
    AWS_ACCESS_KEY_ID=cfg.oauth.awsKeyId;
    AWS_ACCESS_KEY=cfg.oauth.awsKey;
    FARADAY_HTTP_BACKEND="typhoeus";
    DEFAULT_HTTP_USER_AGENT=cfg.user_agent;
    ALLOW_JSONPATH_EVAL=(if cfg.allowUnsafeEval then "true" else "false");
    ENABLE_INSECURE_AGENTS=(if cfg.allowUnsafeAgents then "true" else "false");
    ENABLE_SECOND_PRECISION_SCHEDULE=(if cfg.allowPreciseSchedule then "true" else "false");
    SCHEDULER_FREQUENCY=cfg.scheduleFrequency;
    EVENT_EXPIRATION_CHECK=cfg.eventExperationCheck;
    TIMEZONE=cfg.timeZone;
    FAILED_JOBS_TO_KEEP=(toString cfg.failedJobs);
    DELAYED_JOB_MAX_RUNTIME=(toString cfg.delayedJobMaxTime);
    DELAYED_JOB_SLEEP_DELAY=(toString cfg.delayedJobSleep);
};
  #don't polute env with empty vars
  filteredHuginnEnv = filterAttrs(n: v: v!= "") huginnEnv;
#################################################################################
#### Environment file for Huginn
#################################################################################
  envFileRaw = pkgs.writeText "envfile" ''
#empty file everything is in the env properly.
  '';
#################################################################################
#### Unicorn file for Huginn
#################################################################################
  unicornRaw = pkgs.writeText "unicorn.rb" ''
#wd = File.expand_path(File.join(File.dirname(__FILE__), '..'))
wd = "${cfg.packages.huginn}/share/huginn"
app_path = wd

worker_processes ${toString cfg.unicornWorkers}
preload_app true
timeout 180
listen "${toString cfg.huginnSocket}"

working_directory app_path

rails_env = ENV['RAILS_ENV'] || 'production'

# Log everything to one file
stderr_path "${cfg.statePath}/log/unicorn.log"
stdout_path "${cfg.statePath}/log/unicorn.log"

# Set master PID location
pid "${cfg.statePath}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
  '';

#################################################################################
#### procfile file for Huginn
#################################################################################
  procFileRaw = pkgs.writeText "procfile" ''
${if cfg.enableUnicorn then ''
web: bundle exec unicorn -c ${unicornFile}
'' else ''
web: bundle exec rails server -p ${toString cfg.port} -b ${cfg.listenAddress} -P ${cfg.statePath}/tmp/pids/rails.pid
''}
jobs: bundle exec rails runner bin/threaded.rb  -P ${cfg.statePath}/tmp/pids/runner.pid
  '';


  huginn-rake = pkgs.stdenv.mkDerivation rec {
    name = "huginn-rake";
    buildInputs = [ cfg.packages.huginn cfg.packages.huginn.env pkgs.makeWrapper ];
    phases = "installPhase fixupPhase";
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${cfg.packages.huginn.env}/bin/bundle $out/bin/huginn-bundle \
          ${concatStrings (mapAttrsToList (name: value: "--set ${name} '${value}' ") filteredHuginnEnv)} \
          --set HUGINN_CONFIG_PATH '${cfg.packages.huginn}/share/huginn/config' \
          --set PATH '${lib.makeBinPath [ config.services.postgresql.package ]}:$PATH' \
          --set RAKEOPT '-f ${cfg.packages.huginn}/share/huginn/Rakefile' \
          --run 'cd ${cfg.packages.huginn}/share/huginn'
      makeWrapper $out/bin/huginn-bundle $out/bin/huginn-rake \
          --add-flags "exec rake"
     '';
  };

in {

  options = {
    services.huginn = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the huginn service.
        '';
      };

      packages.huginn = mkOption {
        type = types.package;
        default = pkgs.huginn;
        description = "Reference to the huginn package";
      };

      huginnSocket = mkOption {
         type = types.str;
         default = "${cfg.statePath}/tmp/sockets/huginn.socket";
         description = "the unicorn socket huginn is using";
      };
      statePath = mkOption {
        type = types.str;
        default = "/var/huginn";
        description = "Huginn state directory, logs are stored here.";
      };

      appSecretToken = mkOption {
        type = types.str;
        default = "";
        description = "Huginn session storage key. Random will generate a new one each time huginn is started.";
      };

      initialUser = mkOption {
        type = types.str;
        default = "admin";
        description = "initial user to seed db with";
      };

      initialPassword = mkOption {
        type = types.str;
        default = "password";
        description = "initial password to seed db with.";
      };

      port = mkOption {
        type = types.int;
        default = 3000;
        description = "When using rails what port huginn listens to for connections.";
      };

      enableUnicorn = mkOption {
        type = types.bool;
        default = false;
        description = "Use unicorn server instead of built in rails one.";
      };

      unicornConfig = mkOption {
        type = types.path;
        default = unicornRaw;
        defaultText = "unicorn.rb";
        example = literalExample ''pkgs.writeText "unicorn.rb" "# my custom ruby unicorn file ..."'';
        description = ''
          Override the unicorn config file used by Huginn. By default,
          NixOS generates one automatically.
        '';
      };

      procFileConfig = mkOption {
        type = types.path;
        default = procFileRaw;
        defaultText = "procfile";
        example = literalExample ''pkgs.writeText "procfile" "# my custom procfile file ..."'';
        description = ''
          Override the procfile used by Huginn. By default,
          NixOS generates one automatically.
        '';
      };

      envFileConfig = mkOption {
        type = types.path;
        default = envFileRaw;
        defaultText = "envfile";
        example = literalExample ''pkgs.writeText "envfile" "# my custom envfile file ..."'';
        description = ''
          Override the envfile used by Huginn. By default,
          NixOS generates one automatically.
        '';
      };
      user_agent = mkOption {
        type = types.str;
        default = "Huginn - https://github.com/cantino/huginn";
        description = "When huginn makes request the user agent string it presents.";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Hostname for huginn service, defaults to localhost.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "When using rails what interface huginn listens to for connections.";
      };

      user = mkOption {
        type = types.str;
        default = "huginn";
        description = "User to run huginn and all related services.";
      };

      group = mkOption {
        type = types.str;
        default = "huginn";
        description = "Group to run huginn and all related services.";
      };

      databaseName = mkOption {
        type = types.str;
        default = "huginn";
        description = "Huginn's database name";
      };

      databasePool = mkOption {
        type = types.int;
        default = 10;
        description = "Number of connections for huginn to pool to database";
      };

      databaseUser = mkOption {
        type = types.str;
        default = "huginn";
        description = "Huginn's database username";
      };

      databasePassword = mkOption {
        type = types.str;
        default = "";
        description = "Huginn's database password, if left blank a random one is generated for you";
      };

      databaseHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Huginn's database address";
      };

      databasePort = mkOption {
        type = types.int;
        default = 5432;
        description = "Huginn's database password, if left blank a random one is generated for you";
      };

      assetHost = mkOption {
        type = types.str;
        default = "";
        description = "Huginn's asset host. for serving assets from some other cdn";
      };

      forceSSL = mkOption {
        type = types.bool;
        default = false;
        description = "Force all connections to huginn to come in over ssl or not.";
      };

      agentLogLength = mkOption {
        type = types.int;
        default = 200;
        description = "The number of logs lines to keep per agent.";
      };

      allowUnsafeEval = mkOption {
        type = types.bool;
        default = false;
        description = "You should not allow this option a shared huginn box. It is insecure.";
      };

      allowUnsafeAgents = mkOption {
        type = types.bool;
        default = false;
        description = "You should not allow this option a shared huginn box. It gives shell access to users.";
      };

      allowPreciseSchedule = mkOption {
        type = types.bool;
        default = false;
        description = "Allows for people to schedule tasks on a per second basis. Can lead to overload";
      };

      scheduleFrequency = mkOption {
        type = types.str;
        default = "0.3";
        description = "Default value of 0.3 increasing this will help reduce load, at expense of timing accuracy";
      };

       eventExperationCheck = mkOption {
        type = types.str;
        default = "6h";
        description = "How often scheduler cleans up expired events";
      };

      timeZone = mkOption {
        type = types.str;
        default = "UTC";
        description = "The timeone huginn is set to.  use rake time:zones:local to see correct format for your zone";
      };

      failedJobs = mkOption {
        type = types.int;
        default = 100;
        description = "The number of failed jobs to keep in Huginn's database";
      };

      delayedJobMaxTime = mkOption {
        type = types.int;
        default = 2;
        description = "The number of minutes to let a delayed job task run";
      };

      delayedJobSleep = mkOption {
        type = types.int;
        default = 10;
        description = "The number of seconds to sleep before checking for new jobs";
      };

      unicornWorkers = mkOption {
        type = types.int;
        default = 2;
        description = "The number of unicorn workers to spawn";
      };

      smtp = {
        domain = mkOption {
          type = types.str;
          default = "localhost";
          description = "The SMTP domain huginn will use.";
        };
        user = mkOption {
          type = types.str;
          default = "nixosUser";
          description = "The username used to login to the SMTP server.";
        };
        password = mkOption {
          type = types.str;
          default = "password";
          description = "The password used to login to the SMTP server.";
        };
        server = mkOption {
          type = types.str;
          default = "localhost";
          description = "The SMTP server you are logging into and sending mail from.";
        };
        port = mkOption {
          type = types.int;
	  default = 587;
	  description = "The port we are connecting to on the SMTP server.";
	};
	authenticationType = mkOption {
	  type = types.str;
	  default = "plain";
	  description = "The type of authentication method used for SMTP server.";
	};
	enableTLS = mkOption {
	  type = types.bool;
	  default = true;
	  description = "Use TLS encryption for your connection to the SMTP server.";
	};
	fromAddress = mkOption {
	  type = types.str;
	  default = "nixos@localhost";
	  description = "The from address in the email.";
	};
      };
      oauth = {
        twitterKey = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth key that is used for twitter access.";
	};
	twitterSecret = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth secret that is used for twitter access.";
	};
	thirtySevenSignalsKey = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth key that is used for thirty seven signals access.";
	};
	thirtySevenSignalsSecret = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth secret that is used for thirty seven signals access.";
	};
	gitHubKey = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth key that is used for git hub access.";
	};
	gitHubSecret = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth secret that is used for git hubr access.";
	};
	tumblrKey = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth key that is used for tumblr access.";
	};
	tumblrSecret = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth secret that is used for tumblr access.";
	};
        dropBoxKey = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth key that is used for drop box access.";
	};
	dropBoxSecret = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth secret that is used for drop box access.";
	};
	wunderlistKey = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth key that is used for wunderlist access.";
	};
	wunderlistSecret = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth secret that is used for wunderlist access.";
	};
	everNoteKey = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth key that is used for ever note access.";
	};
	everNoteSecret = mkOption {
	  type = types.str;
	  default = "";
	  description = "The oauth secret that is used for ever note access.";
	};
	awsKeyId = mkOption {
	  type = types.str;
	  default = "";
	  description = "The key id that is used by amazon web services.";
	};
	awsKey = mkOption {
	  type = types.str;
	  default = "";
	  description = "The secret key that is used by amazon web services.";
	};
      };
      registration = {
        invitationCode = mkOption {
          type = types.str;
          default = "";
          description = "This invitation code will be required for users to signup with your Huginn installation. if unset random will be generated";
        };
	skipInvitation = mkOption {
          type = types.bool;
          default = false;
          description = "If true new users will not need an invitation to register";
        };
        requireConfirmation = mkOption {
          type = types.bool;
          default = false;
          description = "If true new users will need to confrim their email address after signup";
        };
	unconfirmedDuration = mkOption {
          type = types.str;
          default = "2.days";
          description = "requireConfirmation is true, set this to the duration in which a user needs to confirm their email address.";
        };
	confirmWithin =  mkOption {
          type = types.str;
          default = "3.days";
          description = "Duration the email confirmation token is valid";
        };
	minPassword = mkOption {
          type = types.int;
	  default = 8;
	  description = "Minimum length for user passwords";
	};
	resetWithin = mkOption {
	  type = types.str;
	  default = "6.hours";
	  description = "Duration for which reset password token is valid";
	};
	enableUserLockout = mkOption {
	  type = types.bool;
	  default = true;
	  description = "If true lock user accounts for the unlockAfter period they fail maxFailedLogin login attempts. If false to allow unlimited failed login attempts.";
	};
	maxFailedLogin = mkOption {
	  type = types.int;
	  default = 10;
	  description = "After how many failed login attempts the account is unlocked when lockStrategy is set to failed_attempts.";
	};
	unlockStrategy = mkOption {
	  type = types.str;
	  default = "both";
	  description = "Can be set to 'email', 'time', 'both' or 'none'. 'none' requires manual unlocking of your users!";
	};
	unlockAfter = mkOption {
	  type = types.str;
	  default = "1.hour";
	  description = "Duration after which the user is unlocked.";
	};
	sessionDuration = mkOption {
	  type = types.str;
	  default = "4.weeks";
	  description = "Duration for which the user will be remembered without asking for creditials again.";
	};
	enableScenarioDefaults = mkOption {
	  type = types.bool;
	  default = true;
	  description = "Set to 'true' if you would prefer new users to start with a default set of agents";
	};
	defaultScenario = mkOption {
	  type = types.str;
	  default = "";
	  description = "Path to a different default scenario for users to use. If blank uses standard default scenario.";
	};
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ huginn-rake ];

    # We use postgres as the main data store.
    services.postgresql.enable = mkDefault true;

    users.extraUsers = [
      { name = cfg.user;
        group = cfg.group;
        home = "${cfg.statePath}/";
        shell = "${pkgs.bash}/bin/bash";
        uid = config.ids.uids.huginn;
      }
    ];

    users.extraGroups = [
      { name = cfg.group;
        gid = config.ids.gids.huginn;
      }
    ];

    systemd.services.huginn = {
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = filteredHuginnEnv;
      path = with pkgs; [
        config.services.postgresql.package
      ];
      preStart = ''
        rm -rf ${cfg.statePath}/tmp
        mkdir -p ${cfg.statePath}/log
        mkdir -p ${cfg.statePath}/tmp/pids
	mkdir -p ${cfg.statePath}/tmp/cache
        mkdir -p ${cfg.statePath}/tmp/sockets

        touch ${cfg.statePath}/tmp/secrets
	if [ "${cfg.appSecretToken}" = "" ]; then
	  printf "APP_SECRET_TOKEN=" >>  ${cfg.statePath}/tmp/secrets
          tr -dc A-Za-z0-9 < /dev/urandom 2> /dev/null | head -c 32 >> ${cfg.statePath}/tmp/secrets
	  echo "" >> ${cfg.statePath}/tmp/secrets
	fi
        if [ "${cfg.databasePassword}" = "" ]; then
	  printf "DATABASE_PASSWORD=" >> ${cfg.statePath}/tmp/secrets
	  if ! test -e "${cfg.statePath}/db-created"; then
	    tr -dc A-Za-z0-9 < /dev/urandom 2> /dev/null | head -c 32 > ${cfg.statePath}/db-password
	  fi
          cat ${cfg.statePath}/db-password >> ${cfg.statePath}/tmp/secrets
	  echo "" >> ${cfg.statePath}/tmp/secrets
        fi
        if ! test -e "${cfg.statePath}/invitation_code"; then
           if [ "${cfg.registration.invitationCode}" = "" ]; then
             tr -dc A-Za-z0-9 < /dev/urandom 2> /dev/null | head -c 32 > ${cfg.statePath}/invitation_code
	   fi
	fi
	if [ "${cfg.registration.invitationCode}" = "" ]; then
	  printf "INVITATION_CODE=" >> ${cfg.statePath}/tmp/secrets
          cat ${cfg.statePath}/invitation_code >> ${cfg.statePath}/tmp/secrets
	  echo "" >> ${cfg.statePath}/tmp/secrets
        fi

	 if [ "${cfg.databaseHost}" = "127.0.0.1" ]; then
          if ! test -e "${cfg.statePath}/db-created"; then
	    if [ "${cfg.databasePassword}" = "" ]; then
	      psql postgres -c "CREATE ROLE huginn WITH LOGIN CREATEDB NOCREATEROLE NOCREATEUSER ENCRYPTED PASSWORD '`cat ${cfg.statePath}/db-password`'"
	    else
              psql postgres -c "CREATE ROLE huginn WITH LOGIN CREATEDB NOCREATEROLE NOCREATEUSER ENCRYPTED PASSWORD '${cfg.databasePassword}'"
	    fi
            ${config.services.postgresql.package}/bin/createdb --owner ${cfg.databaseUser} ${cfg.databaseName} huginn  || true
	    if [ "${cfg.databasePassword}" = "" ]; then
	      echo "creating db"
              ${huginn-rake}/bin/huginn-rake db:create RAILS_ENV=production APP_SECRET_TOKEN="null" DATABASE_PASSWORD=`cat ${cfg.statePath}/db-password`
	      echo "migrating db"
	      ${huginn-rake}/bin/huginn-rake db:migrate RAILS_ENV=production APP_SECRET_TOKEN="null" DATABASE_PASSWORD=`cat ${cfg.statePath}/db-password`
	      echo "seeding db"
	      ${huginn-rake}/bin/huginn-rake db:seed RAILS_ENV=production APP_SECRET_TOKEN="null" SEED_USERNAME=${cfg.initialUser} SEED_PASSWORD=${cfg.initialPassword} DATABASE_PASSWORD=`cat ${cfg.statePath}/db-password` SKIP_INVITATION_CODE=true REQUIRE_CONFIRMED_EMAIL=false
	    else
	      echo "creating db"
              ${huginn-rake}/bin/huginn-rake db:create RAILS_ENV=production APP_SECRET_TOKEN="null"
	      echo "migrating db"
	      ${huginn-rake}/bin/huginn-rake db:migrate RAILS_ENV=production APP_SECRET_TOKEN="null"
	      echo "seeding db"
	      ${huginn-rake}/bin/huginn-rake db:seed RAILS_ENV=production APP_SECRET_TOKEN="null" SEED_USERNAME=${cfg.initialUser} SEED_PASSWORD=${cfg.initialPassword} SKIP_INVITATION_CODE=true REQUIRE_CONFIRMED_EMAIL=false
	    fi
	    touch "${cfg.statePath}/db-created"
          fi
        fi
	#always migrate in case of upgrades
        if [ "${cfg.databasePassword}" = "" ]; then
          ${huginn-rake}/bin/huginn-rake db:migrate RAILS_ENV=production APP_SECRET_TOKEN="null" DATABASE_PASSWORD=`cat ${cfg.statePath}/db-password`
        else
	  ${huginn-rake}/bin/huginn-rake db:migrate RAILS_ENV=production APP_SECRET_TOKEN="null"
	fi

        chown -R ${cfg.user}:${cfg.group} ${cfg.statePath}/
        chmod -R ug+rwX,o-rwx+X ${cfg.statePath}/
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        Restart = "on-failure";
        WorkingDirectory = "${cfg.packages.huginn}/share/huginn";
	ExecStart = "${cfg.packages.huginn.env}/bin/bundle exec foreman start -d . -e ${cfg.statePath}/tmp/secrets,${envFile} -f ${procFile}";
      };

    };

  };
  meta.doc = ./huginn.xml;
}
