{ lib, pkgs }:
let
  inherit (lib) mkOption types;
  json = pkgs.formats.json { };
  runtimePath = types.strMatching "^/[^[:space:]]+$";
  file =
    description:
    mkOption {
      type = types.nullOr runtimePath;
      default = null;
      inherit description;
    };
in
rec {
  instanceOptions = { name, ... }: {
    options = {
      enable = lib.mkEnableOption "Paperclip instance";
      package = mkOption {
        type = types.package;
        default = pkgs.paperclip;
        description = "Native Paperclip package.";
      };
      port = mkOption {
        type = types.port;
        default = 3100;
        description = "Exclusive listening port.";
      };
      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Listen address.";
      };
      stateDir = mkOption {
        type = runtimePath;
        description = "Persistent home root; never moved automatically.";
      };
      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "Prebuilt helper executables available to trusted local adapters.";
      };
      executionProfile = mkOption {
        type = types.enum [
          "trusted-local"
          "remote-only"
        ];
        default = "trusted-local";
        description = "Deployment-owned execution profile, independent of human authentication. trusted-local preserves compatibility. remote-only currently refuses startup: the shared workspace, tools and plugin paths are not yet qualified for controller isolation.";
      };
      publicExposure = mkOption {
        type = types.bool;
        default = false;
        description = "Internet exposure, including a public proxy forwarding to loopback.";
      };
      allowedHostnames = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Allowed hostnames.";
      };
      auth = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Require human authentication.";
        };
        publicBaseUrl = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Canonical browser URL.";
        };
        secretFile = file "Runtime Better Auth signing secret.";
      };
      database = {
        mode = mkOption {
          type = types.enum [
            "embedded-postgres"
            "postgres"
          ];
          default = "embedded-postgres";
          description = "Database provider.";
        };
        embeddedPort = mkOption {
          type = types.port;
          default = 54329;
          description = "Exclusive embedded PostgreSQL port.";
        };
        embeddedUser = mkOption {
          type = types.str;
          default = "paperclip_${name}";
          description = "Embedded cluster role; preserve the old role during explicit migration.";
        };
        embeddedDatabase = mkOption {
          type = types.str;
          default = "paperclip_${name}";
          description = "Embedded database name.";
        };
        embeddedPasswordFile = file "Persistent runtime password for the embedded cluster.";
        dataDir = file "Existing embedded data directory for explicit in-place migration; never copied or reset.";
        urlFile = file "Runtime PostgreSQL URL; not a Nix path value.";
        migrationUrlFile = file "Separate migration connection credential.";
      };
      encryptionKeyFile = file "Persistent encryption key; back up with the database. Omit to generate once in stateDir.";
      telemetry = mkOption {
        type = types.bool;
        default = false;
        description = "Allow first-party telemetry.";
      };
      manifest = mkOption {
        type = types.nullOr json.type;
        default = null;
        description = "Versioned native deployment manifest, validated before dispatch.";
      };
      credentialFiles = mkOption {
        type = types.attrsOf runtimePath;
        default = { };
        description = "Worker credential names mapped to runtime files; contents are never evaluated by Nix.";
      };
      bootstrap = mkOption {
        type = types.nullOr (
          types.submodule {
            options = {
              email = mkOption {
                type = types.str;
                description = "Initial operator email.";
              };
              name = mkOption {
                type = types.str;
                description = "Initial operator name.";
              };
              passwordFile = mkOption {
                type = runtimePath;
                description = "Runtime initial password; existing accounts are never reset.";
              };
            };
          }
        );
        default = null;
        description = "Protected process-local initial administrator bootstrap.";
      };
      settings = mkOption {
        type = json.type;
        default = { };
        description = "Additional upstream config; validated against upstream schema. Cannot override module-owned fields.";
      };
    };
  };
  render =
    name: cfg:
    let
      root = "${cfg.stateDir}/instances/${name}";
      owned = {
        "$meta" = {
          version = 1;
          updatedAt = "1970-01-01T00:00:00.000Z";
          source = "nixos-module";
        };
        server = {
          deploymentMode = if cfg.auth.enable then "authenticated" else "local_trusted";
          exposure = if cfg.publicExposure then "public" else "private";
          inherit (cfg) host port allowedHostnames;
          serveUi = true;
        };
        auth = {
          baseUrlMode = if cfg.auth.publicBaseUrl == null then "auto" else "explicit";
          disableSignUp = true;
        }
        // lib.optionalAttrs (cfg.auth.publicBaseUrl != null) { publicBaseUrl = cfg.auth.publicBaseUrl; };
        database = {
          inherit (cfg.database) mode;
          embeddedPostgresDataDir =
            if cfg.database.dataDir == null then "${root}/db" else cfg.database.dataDir;
          embeddedPostgresPort = cfg.database.embeddedPort;
          backup = {
            enabled = true;
            intervalMinutes = 60;
            retentionDays = 7;
            dir = "${root}/data/backups";
          };
        };
        storage = {
          provider = "local_disk";
          localDisk.baseDir = "${root}/data/storage";
        };
        logging = {
          mode = "file";
          logDir = "${root}/logs";
        };
        secrets = {
          provider = "local_encrypted";
          strictMode = true;
          localEncrypted.keyFilePath = "${root}/secrets/master.key";
        };
        telemetry.enabled = cfg.telemetry;
      };
      overlap =
        a: b:
        lib.any (
          k:
          builtins.hasAttr k b
          && (!(builtins.isAttrs a.${k} && builtins.isAttrs b.${k}) || overlap a.${k} b.${k})
        ) (builtins.attrNames a);
      configFile = json.generate "paperclip-${name}-config.json" (
        assert lib.assertMsg (
          !(overlap owned cfg.settings)
        ) "Paperclip settings cannot override module-owned fields";
        lib.recursiveUpdate cfg.settings owned
      );
      descriptor = {
        version = 1;
        home = cfg.stateDir;
        instance = name;
        inherit configFile;
        inherit (cfg) credentialFiles executionProfile;
        serverCredentials = lib.filterAttrs (_: v: v != null) {
          auth = cfg.auth.secretFile;
          database = cfg.database.urlFile;
          migration = cfg.database.migrationUrlFile;
          encryption = cfg.encryptionKeyFile;
        };
      }
      // lib.optionalAttrs (cfg.manifest != null) {
        manifestFile = json.generate "paperclip-${name}-manifest.json" cfg.manifest;
      }
      // lib.optionalAttrs (cfg.database.mode == "embedded-postgres") {
        embedded = {
          user = cfg.database.embeddedUser;
          database = cfg.database.embeddedDatabase;
          passwordFile = cfg.database.embeddedPasswordFile;
        };
      }
      // lib.optionalAttrs (cfg.bootstrap != null) { inherit (cfg) bootstrap; };
    in
    {
      inherit configFile;
      descriptorFile = json.generate "paperclip-${name}-deployment.json" descriptor;
    };
  assertions =
    instances:
    let
      names = builtins.attrNames instances;
      all = builtins.attrValues instances;
      paths = map (c: c.stateDir) all;
      ports = lib.concatMap (
        c: [ c.port ] ++ lib.optional (c.database.mode == "embedded-postgres") c.database.embeddedPort
      ) all;
      credentials = lib.concatMap (
        c:
        lib.filter (p: p != null) [
          c.auth.secretFile
          c.database.embeddedPasswordFile
          c.encryptionKeyFile
        ]
      ) all;
      databaseDir = name: instances.${name}.database.dataDir or null;
      overlaps = a: b: a == b || lib.hasPrefix "${a}/" b || lib.hasPrefix "${b}/" a;
      validPath =
        p:
        lib.hasPrefix "/" p
        && p != "/"
        && !(lib.hasPrefix "/nix/store" p)
        && !(lib.hasSuffix "/" p)
        && !(lib.hasInfix "//" p)
        && lib.all (s: s != "." && s != "..") (lib.splitString "/" p);
    in
    [
      {
        assertion = lib.all (n: builtins.match "[a-z][a-z0-9_-]{0,30}" n != null) names;
        message = "Paperclip instance names must be lowercase safe identifiers (max 31 characters).";
      }
      {
        assertion = builtins.length ports == builtins.length (lib.unique ports);
        message = "Paperclip listening and embedded database ports must be distinct.";
      }
      {
        assertion = builtins.length credentials == builtins.length (lib.unique credentials);
        message = "Paperclip instances require distinct authentication, encryption and embedded database credential files.";
      }
      {
        assertion = lib.all (
          p:
          validPath p
          &&
            builtins.length (lib.filter (q: p == q || lib.hasPrefix "${p}/" q || lib.hasPrefix "${q}/" p) paths)
            == 1
        ) paths;
        message = "Paperclip state directories must be normalized, non-store and non-overlapping.";
      }
      {
        assertion = lib.all (
          name:
          databaseDir name == null
          || lib.all (
            other:
            name == other
            || (
              !(overlaps (databaseDir name) instances.${other}.stateDir)
              && (databaseDir other == null || !(overlaps (databaseDir name) (databaseDir other)))
            )
          ) names
        ) names;
        message = "Paperclip explicit database directories must not overlap another instance's database or state root.";
      }
    ]
    ++ lib.concatLists (
      lib.mapAttrsToList (name: c: [
        {
          assertion =
            c.auth.enable
            || lib.elem c.host [
              "127.0.0.1"
              "::1"
              "localhost"
            ];
          message = "Paperclip ${name}: untrusted network binding requires authentication.";
        }
        {
          assertion = c.auth.secretFile != null;
          message = "Paperclip ${name}: scoped agent tokens require auth.secretFile, including local-trusted mode.";
        }
        {
          assertion =
            !c.publicExposure
            || (c.auth.enable && c.auth.publicBaseUrl != null && c.database.mode == "postgres");
          message = "Paperclip ${name}: public exposure requires authentication, a canonical URL and PostgreSQL.";
        }
        {
          assertion = c.database.mode != "postgres" || c.database.urlFile != null;
          message = "Paperclip ${name}: external PostgreSQL requires database.urlFile.";
        }
        {
          assertion = c.database.mode != "embedded-postgres" || c.database.embeddedPasswordFile != null;
          message = "Paperclip ${name}: embedded PostgreSQL requires database.embeddedPasswordFile.";
        }
        {
          assertion = lib.all validPath (
            builtins.attrValues c.credentialFiles
            ++ lib.filter (p: p != null) [
              c.auth.secretFile
              c.database.urlFile
              c.database.migrationUrlFile
              c.database.embeddedPasswordFile
              c.database.dataDir
              c.encryptionKeyFile
            ]
            ++ lib.optional (c.bootstrap != null) c.bootstrap.passwordFile
          );
          message = "Paperclip ${name}: credential sources must be runtime paths outside the Nix store.";
        }
      ]) instances
    );
}
