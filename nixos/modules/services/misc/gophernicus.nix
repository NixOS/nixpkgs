{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.gophernicus;
  opt = options.services.gophernicus;
in
{
  options.services.gophernicus = {
    enable = lib.mkEnableOption "gophernicus, a modern gopher daemon";
    package = lib.mkPackageOption pkgs "gophernicus" { };

    domain = lib.mkOption {
      type = lib.types.str;
      description = "A DNS-resolvable domain pointing to this machine or a reverse proxy redirecting here.";
      example = "gopher.example.com";
    };

    path = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = ''
        Packages with content in {file}`/bin` that should be available to gophernicus.

        This will be provided as {env}`PATH` to both gophermaps, cgi scripts and filters.
      '';
      default = with pkgs; [
        coreutils
        gnused
        whoami
        bash
        php
        perl
      ];
      defaultText = lib.literalExpression ''
        with pkgs; [
          coreutils
          gnused
          whoami
          bash
          php
          perl
        ]
      '';
    };

    filters = lib.mkOption {
      type = lib.types.attrsOf lib.types.pathInStore;
      description = "Executables that should be registered as preprocessing filters.";
      default = { };
      example = lib.literalExpression ''
        {
          # Files with the `.txt` extension should be preprocessed with `my-filter`
          txt = pkgs.writeShellScript "my-filter" '''
            echo "To whom it may concern..."
            # First argument is the path of the file being filtered
            cat "$1"
            echo "Best regards, server owner"
          ''';
          # Files with the `.php` extension should automatically be rendered by php
          php = "''${pkgs.php}/bin/php";
        }
      '';
    };

    rootDir = lib.mkOption {
      type = lib.types.path;
      description = ''
        The directory which contains the root of your gopher content.

        Note that you might want to disable {option}`services.gophernicus.enableDefaultRootIndex` if you are
        modifying the contents of your root directory.
      '';
      default = "/var/lib/gophernicus/gopher";
      example = lib.literalExpression ''
        pkgs.symlinkJoin {
          name = "gophernicus-root-dir";
          paths = [
            (pkgs.writeTextDir "gophermap" '''
              iHello!

              1Misc\tmisc
            ''')
            (pkgs.writeTextDir "misc/info.txt" '''
              World
            ''')
          ];
        }
      '';
    };

    enableDefaultRootIndex = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the example gophermap shipped with gophernicus as the default root index.";
      default = true;
      example = false;
    };

    enableUserDirs = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to host content from {file}`~/public_gopher` in user home directories.";
      default = true;
      example = false;
    };

    listenStreams = lib.mkOption {
      description = ''
        Which sockets to bind to.

        See {option}`systemd.sockets.«name».listenStreams`.
      '';
      type = lib.types.listOf lib.types.str;
      default = [ "127.0.0.1:70" ];
      example = [ "/run/gophernicus/gophernicus.sock" ];
    };

    extraArgs = lib.mkOption {
      description = ''
        Extra commandline arguments to pass to {command}`gophernicus`.

        See {manpage}`gophernicus(8)` for available arguments.
      '';
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      example = {
        u = "gopher_stuff";
        w = 80;
        np = true;
        nx = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gophernicus.path = opt.path.default;

    systemd.packages = [ cfg.package ];

    systemd.sockets."gophernicus" = {
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "" ] ++ cfg.listenStreams;
    };

    systemd.services."gophernicus@" = {
      documentation = [ "man:gophernicus(8)" ];
      serviceConfig = {
        DynamicUser = true;
        User = "gophernicus";
        Group = "gophernicus";

        StateDirectory = [ "gophernicus/gopher" ];

        RuntimeDirectory = [ "gophernicus/bin" ];
        BindReadOnlyPaths =
          let
            binDir = pkgs.symlinkJoin {
              name = "gophernicus-bin";
              paths = cfg.path;
              stripPrefix = "/bin";
            };
          in
          [
            "${binDir}:/run/gophernicus/bin"
          ]
          ++ lib.optionals (cfg.rootDir != opt.rootDir.default) [
            "${cfg.rootDir}:/var/lib/gophernicus/gopher"
          ]
          ++ lib.optionals cfg.enableDefaultRootIndex [
            "${cfg.package}/share/gophernicus/gopher/gophermap:/var/lib/gophernicus/gopher/gophermap"
          ];

        ExecStart =
          let
            args = lib.cli.toGNUCommandLineShell { } (
              {
                r = "/var/lib/gophernicus/gopher";
                h = cfg.domain;
                f = if cfg.filters != { } then pkgs.linkFarm "gophernicus-filters" cfg.filters else null;
                nu = !cfg.enableUserDirs;
              }
              // cfg.extraArgs
            );
          in
          [
            ""
            "${lib.getExe cfg.package} ${args}"
          ];

        PrivateUsers = !cfg.enableUserDirs;
        ProtectHome = if cfg.enableUserDirs then "read-only" else true;

        ProcSubset = "pid";
        ProtectProc = "invisible";
        UMask = "0077";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        SystemCallArchitectures = "native";
      };
    };
  };

  meta.maintainers = [
    lib.maintainers.h7x4
  ];
}
