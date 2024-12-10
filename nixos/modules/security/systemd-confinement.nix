{
  config,
  pkgs,
  lib,
  utils,
  ...
}:

let
  toplevelConfig = config;
  inherit (lib) types;
  inherit (utils.systemdUtils.lib) mkPathSafeName;
in
{
  options.systemd.services = lib.mkOption {
    type = types.attrsOf (
      types.submodule (
        { name, config, ... }:
        {
          options.confinement.enable = lib.mkOption {
            type = types.bool;
            default = false;
            description = ''
              If set, all the required runtime store paths for this service are
              bind-mounted into a `tmpfs`-based
              {manpage}`chroot(2)`.
            '';
          };

          options.confinement.fullUnit = lib.mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to include the full closure of the systemd unit file into the
              chroot, instead of just the dependencies for the executables.

              ::: {.warning}
              While it may be tempting to just enable this option to
              make things work quickly, please be aware that this might add paths
              to the closure of the chroot that you didn't anticipate. It's better
              to use {option}`confinement.packages` to **explicitly** add additional store paths to the
              chroot.
              :::
            '';
          };

          options.confinement.packages = lib.mkOption {
            type = types.listOf (types.either types.str types.package);
            default = [ ];
            description =
              let
                mkScOption = optName: "{option}`serviceConfig.${optName}`";
              in
              ''
                Additional packages or strings with context to add to the closure of
                the chroot. By default, this includes all the packages from the
                ${
                  lib.concatMapStringsSep ", " mkScOption [
                    "ExecReload"
                    "ExecStartPost"
                    "ExecStartPre"
                    "ExecStop"
                    "ExecStopPost"
                  ]
                } and ${mkScOption "ExecStart"} options. If you want to have all the
                dependencies of this systemd unit, you can use
                {option}`confinement.fullUnit`.

                ::: {.note}
                The store paths listed in {option}`path` are
                **not** included in the closure as
                well as paths from other options except those listed
                above.
                :::
              '';
          };

          options.confinement.binSh = lib.mkOption {
            type = types.nullOr types.path;
            default = toplevelConfig.environment.binsh;
            defaultText = lib.literalExpression "config.environment.binsh";
            example = lib.literalExpression ''"''${pkgs.dash}/bin/dash"'';
            description = ''
              The program to make available as {file}`/bin/sh` inside
              the chroot. If this is set to `null`, no
              {file}`/bin/sh` is provided at all.

              This is useful for some applications, which for example use the
              {manpage}`system(3)` library function to execute commands.
            '';
          };

          options.confinement.mode = lib.mkOption {
            type = types.enum [
              "full-apivfs"
              "chroot-only"
            ];
            default = "full-apivfs";
            description = ''
              The value `full-apivfs` (the default) sets up
              private {file}`/dev`, {file}`/proc`,
              {file}`/sys`, {file}`/tmp` and {file}`/var/tmp` file systems
              in a separate user name space.

              If this is set to `chroot-only`, only the file
              system name space is set up along with the call to
              {manpage}`chroot(2)`.

              In all cases, unless `serviceConfig.PrivateTmp=true` is set,
              both {file}`/tmp` and {file}`/var/tmp` paths are added to `InaccessiblePaths=`.
              This is to overcome options like `DynamicUser=true`
              implying `PrivateTmp=true` without letting it being turned off.
              Beware however that giving processes the `CAP_SYS_ADMIN` and `@mount` privileges
              can let them undo the effects of `InaccessiblePaths=`.

              ::: {.note}
              This doesn't cover network namespaces and is solely for
              file system level isolation.
              :::
            '';
          };

          config =
            let
              inherit (config.confinement) binSh fullUnit;
              wantsAPIVFS = lib.mkDefault (config.confinement.mode == "full-apivfs");
            in
            lib.mkIf config.confinement.enable {
              serviceConfig = {
                ReadOnlyPaths = [ "+/" ];
                RuntimeDirectory = [ "confinement/${mkPathSafeName name}" ];
                RootDirectory = "/run/confinement/${mkPathSafeName name}";
                InaccessiblePaths = [
                  "-+/run/confinement/${mkPathSafeName name}"
                ];
                PrivateMounts = lib.mkDefault true;

                # https://github.com/NixOS/nixpkgs/issues/14645 is a future attempt
                # to change some of these to default to true.
                #
                # If we run in chroot-only mode, having something like PrivateDevices
                # set to true by default will mount /dev within the chroot, whereas
                # with "chroot-only" it's expected that there are no /dev, /proc and
                # /sys file systems available.
                #
                # However, if this suddenly becomes true, the attack surface will
                # increase, so let's explicitly set these options to true/false
                # depending on the mode.
                MountAPIVFS = wantsAPIVFS;
                PrivateDevices = wantsAPIVFS;
                PrivateTmp = wantsAPIVFS;
                PrivateUsers = wantsAPIVFS;
                ProtectControlGroups = wantsAPIVFS;
                ProtectKernelModules = wantsAPIVFS;
                ProtectKernelTunables = wantsAPIVFS;
              };
              confinement.packages =
                let
                  execOpts = [
                    "ExecReload"
                    "ExecStart"
                    "ExecStartPost"
                    "ExecStartPre"
                    "ExecStop"
                    "ExecStopPost"
                  ];
                  execPkgs = lib.concatMap (
                    opt:
                    let
                      isSet = config.serviceConfig ? ${opt};
                    in
                    lib.flatten (lib.optional isSet config.serviceConfig.${opt})
                  ) execOpts;
                  unitAttrs = toplevelConfig.systemd.units."${name}.service";
                  allPkgs = lib.singleton (builtins.toJSON unitAttrs);
                  unitPkgs = if fullUnit then allPkgs else execPkgs;
                in
                unitPkgs ++ lib.optional (binSh != null) binSh;
            };
        }
      )
    );
  };

  config.assertions = lib.concatLists (
    lib.mapAttrsToList (
      name: cfg:
      let
        whatOpt =
          optName:
          "The 'serviceConfig' option '${optName}' for"
          + " service '${name}' is enabled in conjunction with"
          + " 'confinement.enable'";
      in
      lib.optionals cfg.confinement.enable [
        {
          assertion = !cfg.serviceConfig.RootDirectoryStartOnly or false;
          message =
            "${whatOpt "RootDirectoryStartOnly"}, but right now systemd"
            + " doesn't support restricting bind-mounts to 'ExecStart'."
            + " Please either define a separate service or find a way to run"
            + " commands other than ExecStart within the chroot.";
        }
      ]
    ) config.systemd.services
  );

  config.systemd.packages = lib.concatLists (
    lib.mapAttrsToList (
      name: cfg:
      let
        rootPaths =
          let
            contents = lib.concatStringsSep "\n" cfg.confinement.packages;
          in
          pkgs.writeText "${mkPathSafeName name}-string-contexts.txt" contents;

        chrootPaths =
          pkgs.runCommand "${mkPathSafeName name}-chroot-paths"
            {
              closureInfo = pkgs.closureInfo { inherit rootPaths; };
              serviceName = "${name}.service";
              excludedPath = rootPaths;
            }
            ''
              mkdir -p "$out/lib/systemd/system/$serviceName.d"
              serviceFile="$out/lib/systemd/system/$serviceName.d/confinement.conf"

              echo '[Service]' > "$serviceFile"

              # /bin/sh is special here, because the option value could contain a
              # symlink and we need to properly resolve it.
              ${lib.optionalString (cfg.confinement.binSh != null) ''
                binsh=${lib.escapeShellArg cfg.confinement.binSh}
                realprog="$(readlink -e "$binsh")"
                echo "BindReadOnlyPaths=$realprog:/bin/sh" >> "$serviceFile"
              ''}

              # If DynamicUser= is enabled, PrivateTmp=true is implied (and cannot be turned off).
              # so disable them unless PrivateTmp=true is explicitely set.
              ${lib.optionalString (!cfg.serviceConfig.PrivateTmp) ''
                echo "InaccessiblePaths=-+/tmp" >> "$serviceFile"
                echo "InaccessiblePaths=-+/var/tmp" >> "$serviceFile"
              ''}

              while read storePath; do
                if [ -L "$storePath" ]; then
                  # Currently, systemd can't cope with symlinks in Bind(ReadOnly)Paths,
                  # so let's just bind-mount the target to that location.
                  echo "BindReadOnlyPaths=$(readlink -e "$storePath"):$storePath"
                elif [ "$storePath" != "$excludedPath" ]; then
                  echo "BindReadOnlyPaths=$storePath"
                fi
              done < "$closureInfo/store-paths" >> "$serviceFile"
            '';
      in
      lib.optional cfg.confinement.enable chrootPaths
    ) config.systemd.services
  );
}
