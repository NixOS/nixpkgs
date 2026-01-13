{
  lib,
  systemdUtils,
  pkgs,
}:

let
  inherit (systemdUtils.lib)
    automountConfig
    makeUnit
    mountConfig
    pathConfig
    sliceConfig
    socketConfig
    stage1ServiceConfig
    stage2ServiceConfig
    targetConfig
    timerConfig
    unitConfig
    ;

  inherit (systemdUtils.unitOptions)
    concreteUnitOptions
    stage1AutomountOptions
    stage1CommonUnitOptions
    stage1MountOptions
    stage1PathOptions
    stage1ServiceOptions
    stage1SliceOptions
    stage1SocketOptions
    stage1TimerOptions
    stage2AutomountOptions
    stage2CommonUnitOptions
    stage2MountOptions
    stage2PathOptions
    stage2ServiceOptions
    stage2SliceOptions
    stage2SocketOptions
    stage2TimerOptions
    ;

  inherit (lib)
    mkDefault
    mkDerivedConfig
    mkEnableOption
    mkIf
    mkOption
    optionalString
    strings
    ;

  inherit (lib.attrsets)
    optionalAttrs
    ;

  inherit (lib.types)
    attrsOf
    bool
    coercedTo
    either
    enum
    lines
    listOf
    nullOr
    oneOf
    package
    path
    singleLineStr
    str
    submodule
    ;

  initrdStorePathModule =
    { config, ... }:
    {
      options = {
        enable = (mkEnableOption "copying of this file and symlinking it") // {
          default = true;
        };

        target = mkOption {
          type = nullOr path;
          description = ''
            Path of the symlink.
          '';
          default = null;
        };

        source = mkOption {
          type = path;
          description = "Path of the source file.";
        };

        dlopen = {
          usePriority = mkOption {
            type = enum [
              "required"
              "recommended"
              "suggested"
            ];
            default = "recommended";
            description = ''
              Priority of dlopen ELF notes to include. "required" is
              minimal, "recommended" includes "required", and
              "suggested" includes "recommended".

              See: <https://systemd.io/ELF_DLOPEN_METADATA/>
            '';
          };

          features = mkOption {
            type = listOf singleLineStr;
            default = [ ];
            description = ''
              Features to enable via dlopen ELF notes. These will be in
              addition to anything included via 'usePriority',
              regardless of their priority.
            '';
          };
        };
      };
    };

in

{
  units = attrsOf (
    submodule (
      { name, config, ... }:
      {
        options = concreteUnitOptions;
        config = {
          name = mkDefault name;
          unit = mkDefault (makeUnit name config);
        };
      }
    )
  );

  services = attrsOf (submodule [
    stage2ServiceOptions
    unitConfig
    stage2ServiceConfig
  ]);
  initrdServices = attrsOf (submodule [
    stage1ServiceOptions
    unitConfig
    stage1ServiceConfig
  ]);

  targets = attrsOf (submodule [
    stage2CommonUnitOptions
    unitConfig
    targetConfig
  ]);
  initrdTargets = attrsOf (submodule [
    stage1CommonUnitOptions
    unitConfig
    targetConfig
  ]);

  sockets = attrsOf (submodule [
    stage2SocketOptions
    unitConfig
    socketConfig
  ]);
  initrdSockets = attrsOf (submodule [
    stage1SocketOptions
    unitConfig
    socketConfig
  ]);

  timers = attrsOf (submodule [
    stage2TimerOptions
    unitConfig
    timerConfig
  ]);
  initrdTimers = attrsOf (submodule [
    stage1TimerOptions
    unitConfig
    timerConfig
  ]);

  paths = attrsOf (submodule [
    stage2PathOptions
    unitConfig
    pathConfig
  ]);
  initrdPaths = attrsOf (submodule [
    stage1PathOptions
    unitConfig
    pathConfig
  ]);

  slices = attrsOf (submodule [
    stage2SliceOptions
    unitConfig
    sliceConfig
  ]);
  initrdSlices = attrsOf (submodule [
    stage1SliceOptions
    unitConfig
    sliceConfig
  ]);

  mounts = listOf (submodule [
    stage2MountOptions
    unitConfig
    mountConfig
  ]);
  initrdMounts = listOf (submodule [
    stage1MountOptions
    unitConfig
    mountConfig
  ]);

  automounts = listOf (submodule [
    stage2AutomountOptions
    unitConfig
    automountConfig
  ]);
  initrdAutomounts = attrsOf (submodule [
    stage1AutomountOptions
    unitConfig
    automountConfig
  ]);

  initrdStorePath = listOf (
    coercedTo (oneOf [
      singleLineStr
      package
    ]) (source: { inherit source; }) (submodule initrdStorePathModule)
  );

  initrdContents = attrsOf (
    submodule (
      {
        config,
        options,
        name,
        ...
      }:
      {
        imports = [ initrdStorePathModule ];
        options = {
          text = mkOption {
            default = null;
            type = nullOr lines;
            description = "Text of the file.";
          };
        };

        config = {
          target = mkDefault name;
          source = mkIf (config.text != null) (
            let
              name' = "initrd-" + baseNameOf name;
            in
            mkDerivedConfig options.text (pkgs.writeText name')
          );
        };
      }
    )
  );

  mkCredentialOption =
    {
      defaultName,
      readOnlyName ? false,
      bindPath ? null,
      asserted ? false,
      conditional ? false,
      description,
      nullable ? false,
    }:
    mkOption (
      optionalAttrs nullable {
        default = null;
      }
    )
    // {
      type = (if nullable then nullOr else lib.id) (oneOf [
        path
        singleLineStr
        (submodule {
          options = {
            name = mkOption {
              type = singleLineStr;
              description = "The name of the credential";
              default = defaultName;
              readOnly = readOnlyName;
            };
            encrypted = mkOption {
              type = bool;
              description = "Whether the credential is encrypted with systemd-creds";
              default = false;
            };
            path = mkOption {
              type = nullOr (either path singleLineStr);
              description = "The path of the credential data. If given, the credential will be consumed via `LoadCredential[Encrypted]`";
              default = null;
            };
            data = mkOption {
              type = nullOr str;
              description = "The credential data. If given, the credential will be consumed via `SetCredential[Encrypted]`";
              default = null;
            };
            reference = mkOption {
              type = nullOr str;
              description = "The credential reference. If given, the credential will be consumed via `ImportCredential`";
              default = null;
            };
            allowStorePath = mkOption {
              type = bool;
              description = "Set to true to opt into allowing store paths for secrets. This isn't generally safe as store paths are readable by anyone";
              default = false;
            };
          };
        })
      ]);
      description = ''
        ${description}

        The secret will be passed to the service via systemd-creds, as per the documentation here <https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#Credentials>

        The secret may be given as a string/path, in which case it is taken to
        have the default name, to be unencrypted, and to be a path per the
        systemd documentation for `LoadCredential`.
      '';
      apply =
        credential:
        optionalAttrs (credential != null) (
          let
            cred =
              if strings.isStringLike credential then
                {
                  name = defaultName;
                  encrypted = false;
                  path = credential;
                  data = null;
                  reference = null;
                  allowStorePath = false;
                }
              else
                credential;
            encrypted = optionalString cred.encrypted "Encrypted";
            assertStringPath =
              value:
              if !cred.allowStorePath && (strings.isStorePath value || builtins.isPath value) then
                throw ''
                  Credential '${cred.name}':
                    ${toString value}
                    is a path into the world-readable Nix store. This is not generally safe for secrets.

                    This protection may be circumvented via the 'allowStorePath' option.
                ''
              else
                value;
          in
          cred
          // {
            serviceConfig = {
              BindPaths = if bindPath != null then [ "%d/${cred.name}:${bindPath}" ] else [ ];
              AssertCredential = if asserted then [ cred.name ] else [ ];
              ConditionCredential = if conditional then [ cred.name ] else [ ];
            }
            // (
              if cred.data != null && cred.reference == null && cred.path == null then
                { ImportCredential = "${cred.ref}:${cred.name}"; }
              else if cred.data == null && cred.reference != null && cred.path == null then
                { "SetCredential${encrypted}" = "${cred.name}:${cred.data}"; }
              else if cred.data == null && cred.reference == null then
                {
                  "LoadCredential${encrypted}" =
                    if cred.path != null then "${cred.name}:${assertStringPath cred.path}" else cred.name;
                }
              else
                throw "Credential must be given at most one data, path, or reference"
            );
          }
        );
    };
}
