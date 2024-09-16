{ config, lib, pkgs, ... }:
let
  cfg = config.services.athens;

  athensConfig = lib.flip lib.recursiveUpdate cfg.extraConfig (
    {
      GoBinary = "${cfg.goBinary}/bin/go";
      GoEnv = cfg.goEnv;
      GoBinaryEnvVars = lib.mapAttrsToList (k: v: "${k}=${v}") cfg.goBinaryEnvVars;
      GoGetWorkers = cfg.goGetWorkers;
      GoGetDir = cfg.goGetDir;
      ProtocolWorkers = cfg.protocolWorkers;
      LogLevel = cfg.logLevel;
      CloudRuntime = cfg.cloudRuntime;
      EnablePprof = cfg.enablePprof;
      PprofPort = ":${toString cfg.pprofPort}";
      FilterFile = cfg.filterFile;
      RobotsFile = cfg.robotsFile;
      Timeout = cfg.timeout;
      StorageType = cfg.storageType;
      TLSCertFile = cfg.tlsCertFile;
      TLSKeyFile = cfg.tlsKeyFile;
      Port = ":${toString cfg.port}";
      UnixSocket = cfg.unixSocket;
      GlobalEndpoint = cfg.globalEndpoint;
      BasicAuthUser = cfg.basicAuthUser;
      BasicAuthPass = cfg.basicAuthPass;
      ForceSSL = cfg.forceSSL;
      ValidatorHook = cfg.validatorHook;
      PathPrefix = cfg.pathPrefix;
      NETRCPath = cfg.netrcPath;
      GithubToken = cfg.githubToken;
      HGRCPath = cfg.hgrcPath;
      TraceExporter = cfg.traceExporter;
      StatsExporter = cfg.statsExporter;
      SumDBs = cfg.sumDBs;
      NoSumPatterns = cfg.noSumPatterns;
      DownloadMode = cfg.downloadMode;
      NetworkMode = cfg.networkMode;
      DownloadURL = cfg.downloadURL;
      SingleFlightType = cfg.singleFlightType;
      IndexType = cfg.indexType;
      ShutdownTimeout = cfg.shutdownTimeout;
      SingleFlight = {
        Etcd = {
          Endpoints = builtins.concatStringsSep "," cfg.singleFlight.etcd.endpoints;
        };
        Redis = {
          Endpoint = cfg.singleFlight.redis.endpoint;
          Password = cfg.singleFlight.redis.password;
          LockConfig = {
            TTL = cfg.singleFlight.redis.lockConfig.ttl;
            Timeout = cfg.singleFlight.redis.lockConfig.timeout;
            MaxRetries = cfg.singleFlight.redis.lockConfig.maxRetries;
          };
        };
        RedisSentinel = {
          Endpoints = cfg.singleFlight.redisSentinel.endpoints;
          MasterName = cfg.singleFlight.redisSentinel.masterName;
          SentinelPassword = cfg.singleFlight.redisSentinel.sentinelPassword;
          LockConfig = {
            TTL = cfg.singleFlight.redisSentinel.lockConfig.ttl;
            Timeout = cfg.singleFlight.redisSentinel.lockConfig.timeout;
            MaxRetries = cfg.singleFlight.redisSentinel.lockConfig.maxRetries;
          };
        };
      };
      Storage = {
        CDN = {
          Endpoint = cfg.storage.cdn.endpoint;
        };
        Disk = {
          RootPath = cfg.storage.disk.rootPath;
        };
        GCP = {
          ProjectID = cfg.storage.gcp.projectID;
          Bucket = cfg.storage.gcp.bucket;
          JSONKey = cfg.storage.gcp.jsonKey;
        };
        Minio = {
          Endpoint = cfg.storage.minio.endpoint;
          Key = cfg.storage.minio.key;
          Secret = cfg.storage.minio.secret;
          EnableSSL = cfg.storage.minio.enableSSL;
          Bucket = cfg.storage.minio.bucket;
          region = cfg.storage.minio.region;
        };
        Mongo = {
          URL = cfg.storage.mongo.url;
          DefaultDBName = cfg.storage.mongo.defaultDBName;
          CertPath = cfg.storage.mongo.certPath;
          Insecure = cfg.storage.mongo.insecure;
        };
        S3 = {
          Region = cfg.storage.s3.region;
          Key = cfg.storage.s3.key;
          Secret = cfg.storage.s3.secret;
          Token = cfg.storage.s3.token;
          Bucket = cfg.storage.s3.bucket;
          ForcePathStyle = cfg.storage.s3.forcePathStyle;
          UseDefaultConfiguration = cfg.storage.s3.useDefaultConfiguration;
          CredentialsEndpoint = cfg.storage.s3.credentialsEndpoint;
          AwsContainerCredentialsRelativeURI = cfg.storage.s3.awsContainerCredentialsRelativeURI;
          Endpoint = cfg.storage.s3.endpoint;
        };
        AzureBlob = {
          AccountName = cfg.storage.azureblob.accountName;
          AccountKey = cfg.storage.azureblob.accountKey;
          ContainerName = cfg.storage.azureblob.containerName;
        };
        External = {
          URL = cfg.storage.external.url;
        };
      };
      Index = {
        MySQL = {
          Protocol = cfg.index.mysql.protocol;
          Host = cfg.index.mysql.host;
          Port = cfg.index.mysql.port;
          User = cfg.index.mysql.user;
          Password = cfg.index.mysql.password;
          Database = cfg.index.mysql.database;
          Params = {
            parseTime = cfg.index.mysql.params.parseTime;
            timeout = cfg.index.mysql.params.timeout;
          };
        };
        Postgres = {
          Host = cfg.index.postgres.host;
          Port = cfg.index.postgres.port;
          User = cfg.index.postgres.user;
          Password = cfg.index.postgres.password;
          Database = cfg.index.postgres.database;
          Params = {
            connect_timeout = cfg.index.postgres.params.connect_timeout;
            sslmode = cfg.index.postgres.params.sslmode;
          };
        };
      };
    }
  );

  configFile = pkgs.runCommandLocal "config.toml" { } ''
    ${pkgs.buildPackages.jq}/bin/jq 'del(..|nulls)' \
      < ${pkgs.writeText "config.json" (builtins.toJSON athensConfig)} | \
    ${pkgs.buildPackages.remarshal}/bin/remarshal -if json -of toml \
      > $out
  '';
in
{
  meta = {
    maintainers = pkgs.athens.meta.maintainers;
    doc = ./athens.md;
  };

  options.services.athens = {
    enable = lib.mkEnableOption "Go module datastore and proxy";

    package = lib.mkOption {
      default = pkgs.athens;
      defaultText = lib.literalExpression "pkgs.athens";
      example = "pkgs.athens";
      description = "Which athens derivation to use";
      type = lib.types.package;
    };

    goBinary = lib.mkOption {
      type = lib.types.package;
      default = pkgs.go;
      defaultText = lib.literalExpression "pkgs.go";
      example = "pkgs.go_1_21";
      description = ''
        The Go package used by Athens at runtime.

        Athens primarily runs two Go commands:
        1. `go mod download -json <module>@<version>`
        2. `go list -m -json <module>@latest`
      '';
    };

    goEnv = lib.mkOption {
      type = lib.types.enum [ "development" "production" ];
      description = "Specifies the type of environment to run. One of 'development' or 'production'.";
      default = "development";
      example = "production";
    };

    goBinaryEnvVars = lib.mkOption {
      type = lib.types.attrs;
      description = "Environment variables to pass to the Go binary.";
      example = ''
        { "GOPROXY" = "direct", "GODEBUG" = "true" }
      '';
      default = { };
    };

    goGetWorkers = lib.mkOption {
      type = lib.types.int;
      description = "Number of workers concurrently downloading modules.";
      default = 10;
      example = 32;
    };

    goGetDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        Temporary directory that Athens will use to
        fetch modules from VCS prior to persisting
        them to a storage backend.

        If the value is empty, Athens will use the
        default OS temp directory.
      '';
      default = null;
      example = "/tmp/athens";
    };

    protocolWorkers = lib.mkOption {
      type = lib.types.int;
      description = "Number of workers concurrently serving protocol paths.";
      default = 30;
    };

    logLevel = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "panic" "fatal" "error" "warning" "info" "debug" "trace" ]);
      description = ''
        Log level for Athens.
        Supports all logrus log levels (https://github.com/Sirupsen/logrus#level-logging)".
      '';
      default = "warning";
      example = "debug";
    };

    cloudRuntime = lib.mkOption {
      type = lib.types.enum [ "GCP" "none" ];
      description = ''
        Specifies the Cloud Provider on which the Proxy/registry is running.
      '';
      default = "none";
      example = "GCP";
    };

    enablePprof = lib.mkOption {
      type = lib.types.bool;
      description = "Enable pprof endpoints.";
      default = false;
    };

    pprofPort = lib.mkOption {
      type = lib.types.port;
      description = "Port number for pprof endpoints.";
      default = 3301;
      example = 443;
    };

    filterFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''Filename for the include exclude filter.'';
      default = null;
      example = lib.literalExpression ''
        pkgs.writeText "filterFile" '''
          - github.com/azure
          + github.com/azure/azure-sdk-for-go
          D golang.org/x/tools
        '''
      '';
    };

    robotsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''Provides /robots.txt for net crawlers.'';
      default = null;
      example = lib.literalExpression ''pkgs.writeText "robots.txt" "# my custom robots.txt ..."'';
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      description = "Timeout for external network calls in seconds.";
      default = 300;
      example = 3;
    };

    storageType = lib.mkOption {
      type = lib.types.enum [ "memory" "disk" "mongo" "gcp" "minio" "s3" "azureblob" "external" ];
      description = "Specifies the type of storage backend to use.";
      default = "disk";
    };

    tlsCertFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "Path to the TLS certificate file.";
      default = null;
      example = "/etc/ssl/certs/athens.crt";
    };

    tlsKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "Path to the TLS key file.";
      default = null;
      example = "/etc/ssl/certs/athens.key";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = ''
        Port number Athens listens on.
      '';
      example = 443;
    };

    unixSocket = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to the unix socket file.
        If set, Athens will listen on the unix socket instead of TCP socket.
      '';
      default = null;
      example = "/run/athens.sock";
    };

    globalEndpoint = lib.mkOption {
      type = lib.types.str;
      description = ''
        Endpoint for a package registry in case of a proxy cache miss.
      '';
      default = "";
      example = "http://upstream-athens.example.com:3000";
    };

    basicAuthUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Username for basic auth.
      '';
      default = null;
      example = "user";
    };

    basicAuthPass = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Password for basic auth. Warning: this is stored in plain text in the config file.
      '';
      default = null;
      example = "swordfish";
    };

    forceSSL = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Force SSL redirects for incoming requests.
      '';
      default = false;
    };

    validatorHook = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Endpoint to validate modules against.

        Not used if empty.
      '';
      default = null;
      example = "https://validation.example.com";
    };

    pathPrefix = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Sets basepath for all routes.
      '';
      default = null;
      example = "/athens";
    };

    netrcPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to the .netrc file.
      '';
      default = null;
      example = "/home/user/.netrc";
    };

    githubToken = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Creates .netrc file with the given token to be used for GitHub.
        Warning: this is stored in plain text in the config file.
      '';
      default = null;
      example = "ghp_1234567890";
    };

    hgrcPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to the .hgrc file.
      '';
      default = null;
      example = "/home/user/.hgrc";
    };

    traceExporter = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "jaeger" "datadog" ]);
      description = ''
        Trace exporter to use.
      '';
      default = null;
    };

    traceExporterURL = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        URL endpoint that traces will be sent to.
      '';
      default = null;
      example = "http://localhost:14268";
    };

    statsExporter = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "prometheus" ]);
      description = "Stats exporter to use.";
      default = null;
    };

    sumDBs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        List of fully qualified URLs that Athens will proxy
        that the go command can use a checksum verifier.
      '';
      default = [ "https://sum.golang.org" ];
    };

    noSumPatterns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        List of patterns that Athens sum db proxy will return a 403 for.
      '';
      default = [ ];
      example = [ "github.com/mycompany/*" ];
    };

    downloadMode = lib.mkOption {
      type = lib.types.oneOf [ (lib.types.enum [ "sync" "async" "redirect" "async_redirect" "none" ]) (lib.types.strMatching "^file:.*$|^custom:.*$") ];
      description = ''
        Defines how Athens behaves when a module@version
        is not found in storage. There are 7 options:
        1. "sync": download the module synchronously and
        return the results to the client.
        2. "async": return 404, but asynchronously store the module
        in the storage backend.
        3. "redirect": return a 301 redirect status to the client
        with the base URL as the DownloadRedirectURL from below.
        4. "async_redirect": same as option number 3 but it will
        asynchronously store the module to the backend.
        5. "none": return 404 if a module is not found and do nothing.
        6. "file:<path>": will point to an HCL file that specifies
        any of the 5 options above based on different import paths.
        7. "custom:<base64-encoded-hcl>" is the same as option 6
        but the file is fully encoded in the option. This is
        useful for using an environment variable in serverless
        deployments.
      '';
      default = "async_redirect";
    };

    networkMode = lib.mkOption {
      type = lib.types.enum [ "strict" "offline" "fallback" ];
      description = ''
        Configures how Athens will return the results
        of the /list endpoint as it can be assembled from both its own
        storage and the upstream VCS.

        Note, that for better error messaging, this would also affect how other
        endpoints behave.

        Modes:
        1. strict: merge VCS versions with storage versions, but fail if either of them fails.
        2. offline: only get storage versions, never reach out to VCS.
        3. fallback: only return storage versions, if VCS fails. Note this means that you may
        see inconsistent results since fallback mode does a best effort of giving you what's
        available at the time of requesting versions.
      '';
      default = "strict";
    };

    downloadURL = lib.mkOption {
      type = lib.types.str;
      description = "URL used if DownloadMode is set to redirect.";
      default = "https://proxy.golang.org";
    };

    singleFlightType = lib.mkOption {
      type = lib.types.enum [ "memory" "etcd" "redis" "redis-sentinel" "gcp" "azureblob" ];
      description = ''
        Determines what mechanism Athens uses to manage concurrency flowing into the Athens backend.
      '';
      default = "memory";
    };

    indexType = lib.mkOption {
      type = lib.types.enum [ "none" "memory" "mysql" "postgres" ];
      description = ''
        Type of index backend Athens will use.
      '';
      default = "none";
    };

    shutdownTimeout = lib.mkOption {
      type = lib.types.int;
      description = ''
        Number of seconds to wait for the server to shutdown gracefully.
      '';
      default = 60;
      example = 1;
    };

    singleFlight = {
      etcd = {
        endpoints = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "URLs that determine all distributed etcd servers.";
          default = [ ];
          example = [ "localhost:2379" ];
        };
      };
      redis = {
        endpoint = lib.mkOption {
          type = lib.types.str;
          description = "URL of the redis server.";
          default = "";
          example = "localhost:6379";
        };
        password = lib.mkOption {
          type = lib.types.str;
          description = "Password for the redis server. Warning: this is stored in plain text in the config file.";
          default = "";
          example = "swordfish";
        };

        lockConfig = {
          ttl = lib.mkOption {
            type = lib.types.int;
            description = "TTL for the lock in seconds.";
            default = 900;
            example = 1;
          };
          timeout = lib.mkOption {
            type = lib.types.int;
            description = "Timeout for the lock in seconds.";
            default = 15;
            example = 1;
          };
          maxRetries = lib.mkOption {
            type = lib.types.int;
            description = "Maximum number of retries for the lock.";
            default = 10;
            example = 1;
          };
        };
      };

      redisSentinel = {
        endpoints = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "URLs that determine all distributed redis servers.";
          default = [ ];
          example = [ "localhost:26379" ];
        };
        masterName = lib.mkOption {
          type = lib.types.str;
          description = "Name of the sentinel master server.";
          default = "";
          example = "redis-1";
        };
        sentinelPassword = lib.mkOption {
          type = lib.types.str;
          description = "Password for the sentinel server. Warning: this is stored in plain text in the config file.";
          default = "";
          example = "swordfish";
        };

        lockConfig = {
          ttl = lib.mkOption {
            type = lib.types.int;
            description = "TTL for the lock in seconds.";
            default = 900;
            example = 1;
          };
          timeout = lib.mkOption {
            type = lib.types.int;
            description = "Timeout for the lock in seconds.";
            default = 15;
            example = 1;
          };
          maxRetries = lib.mkOption {
            type = lib.types.int;
            description = "Maximum number of retries for the lock.";
            default = 10;
            example = 1;
          };
        };
      };
    };

    storage = {
      cdn = {
        endpoint = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "hostname of the CDN server.";
          example = "cdn.example.com";
          default = null;
        };
      };

      disk = {
        rootPath = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = "Athens disk root folder.";
          default = "/var/lib/athens";
        };
      };

      gcp = {
        projectID = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "GCP project ID.";
          example = "my-project";
          default = null;
        };
        bucket = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "GCP backend storage bucket.";
          example = "my-bucket";
          default = null;
        };
        jsonKey = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Base64 encoded GCP service account key. Warning: this is stored in plain text in the config file.";
          default = null;
        };
      };

      minio = {
        endpoint = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Endpoint of the minio storage backend.";
          example = "minio.example.com:9001";
          default = null;
        };
        key = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Access key id for the minio storage backend.";
          example = "minio";
          default = null;
        };
        secret = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Secret key for the minio storage backend. Warning: this is stored in plain text in the config file.";
          example = "minio123";
          default = null;
        };
        enableSSL = lib.mkOption {
          type = lib.types.bool;
          description = "Enable SSL for the minio storage backend.";
          default = false;
        };
        bucket = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Bucket name for the minio storage backend.";
          example = "gomods";
          default = null;
        };
        region = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Region for the minio storage backend.";
          example = "us-east-1";
          default = null;
        };
      };

      mongo = {
        url = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "URL of the mongo database.";
          example = "mongodb://localhost:27017";
          default = null;
        };
        defaultDBName = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Name of the mongo database.";
          example = "athens";
          default = null;
        };
        certPath = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = "Path to the certificate file for the mongo database.";
          example = "/etc/ssl/mongo.pem";
          default = null;
        };
        insecure = lib.mkOption {
          type = lib.types.bool;
          description = "Allow insecure connections to the mongo database.";
          default = false;
        };
      };

      s3 = {
        region = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Region of the S3 storage backend.";
          example = "eu-west-3";
          default = null;
        };
        key = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Access key id for the S3 storage backend.";
          example = "minio";
          default = null;
        };
        secret = lib.mkOption {
          type = lib.types.str;
          description = "Secret key for the S3 storage backend. Warning: this is stored in plain text in the config file.";
          default = "";
        };
        token = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Token for the S3 storage backend. Warning: this is stored in plain text in the config file.";
          default = null;
        };
        bucket = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Bucket name for the S3 storage backend.";
          example = "gomods";
          default = null;
        };
        forcePathStyle = lib.mkOption {
          type = lib.types.bool;
          description = "Force path style for the S3 storage backend.";
          default = false;
        };
        useDefaultConfiguration = lib.mkOption {
          type = lib.types.bool;
          description = "Use default configuration for the S3 storage backend.";
          default = false;
        };
        credentialsEndpoint = lib.mkOption {
          type = lib.types.str;
          description = "Credentials endpoint for the S3 storage backend.";
          default = "";
        };
        awsContainerCredentialsRelativeURI = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Container relative url (used by fargate).";
          default = null;
        };
        endpoint = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Endpoint for the S3 storage backend.";
          default = null;
        };
      };

      azureblob = {
        accountName = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Account name for the Azure Blob storage backend.";
          default = null;
        };
        accountKey = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Account key for the Azure Blob storage backend. Warning: this is stored in plain text in the config file.";
          default = null;
        };
        containerName = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Container name for the Azure Blob storage backend.";
          default = null;
        };
      };

      external = {
        url = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "URL of the backend storage layer.";
          example = "https://athens.example.com";
          default = null;
        };
      };
    };

    index = {
      mysql = {
        protocol = lib.mkOption {
          type = lib.types.str;
          description = "Protocol for the MySQL database.";
          default = "tcp";
        };
        host = lib.mkOption {
          type = lib.types.str;
          description = "Host for the MySQL database.";
          default = "localhost";
        };
        port = lib.mkOption {
          type = lib.types.int;
          description = "Port for the MySQL database.";
          default = 3306;
        };
        user = lib.mkOption {
          type = lib.types.str;
          description = "User for the MySQL database.";
          default = "root";
        };
        password = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Password for the MySQL database. Warning: this is stored in plain text in the config file.";
          default = null;
        };
        database = lib.mkOption {
          type = lib.types.str;
          description = "Database name for the MySQL database.";
          default = "athens";
        };
        params = {
          parseTime = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "Parse time for the MySQL database.";
            default = "true";
          };
          timeout = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "Timeout for the MySQL database.";
            default = "30s";
          };
        };
      };

      postgres = {
        host = lib.mkOption {
          type = lib.types.str;
          description = "Host for the Postgres database.";
          default = "localhost";
        };
        port = lib.mkOption {
          type = lib.types.int;
          description = "Port for the Postgres database.";
          default = 5432;
        };
        user = lib.mkOption {
          type = lib.types.str;
          description = "User for the Postgres database.";
          default = "postgres";
        };
        password = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Password for the Postgres database. Warning: this is stored in plain text in the config file.";
          default = null;
        };
        database = lib.mkOption {
          type = lib.types.str;
          description = "Database name for the Postgres database.";
          default = "athens";
        };
        params = {
          connect_timeout = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "Connect timeout for the Postgres database.";
            default = "30s";
          };
          sslmode = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "SSL mode for the Postgres database.";
            default = "disable";
          };
        };
      };
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      description = ''
        Extra configuration options for the athens config file.
      '';
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.athens = {
      description = "Athens Go module proxy";
      documentation = [ "https://docs.gomods.io" ];

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Restart = "on-abnormal";
        Nice = 5;
        ExecStart = ''${cfg.package}/bin/athens -config_file=${configFile}'';

        KillMode = "mixed";
        KillSignal = "SIGINT";
        TimeoutStopSec = cfg.shutdownTimeout;

        LimitNOFILE = 1048576;
        LimitNPROC = 512;

        DynamicUser = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = "read-only";
        ProtectSystem = "full";

        ReadWritePaths = lib.mkIf (cfg.storage.disk.rootPath != null && (! lib.hasPrefix "/var/lib/" cfg.storage.disk.rootPath)) [ cfg.storage.disk.rootPath ];
        StateDirectory = lib.mkIf (lib.hasPrefix "/var/lib/" cfg.storage.disk.rootPath) [ (lib.removePrefix "/var/lib/" cfg.storage.disk.rootPath) ];

        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        NoNewPrivileges = true;
      };
    };

    networking.firewall = {
      allowedTCPPorts = lib.optionals (cfg.unixSocket == null) [ cfg.port ]
        ++ lib.optionals cfg.enablePprof [ cfg.pprofPort ];
    };
  };

}
