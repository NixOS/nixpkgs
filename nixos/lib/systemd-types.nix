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
    strings
    lists
    attrsets
    ;

  inherit (lib.types)
    attrsOf
    coercedTo
    enum
    lines
    listOf
    nullOr
    oneOf
    package
    path
    singleLineStr
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

  credential = nullOr (oneOf [
    path
    singleLineStr
    (submodule {
      options =
        let
          optionalStr = mkOption {
            type = nullOr singleLineStr;
            default = null;
          };
        in
        {
          LoadCredential = optionalStr;
          LoadCredentialEncrypted = optionalStr;
          SetCredential = optionalStr;
          SetCredentialEncrypted = optionalStr;
          ImportCredential = optionalStr;
        };
    })
  ]);
  credentialConfig =
    {
      credential,
      defaultId,
      bindPath ? null,
      nullable ? false,
      conditional ? false,
      asserted ? false,
    }:
    with (
      if !strings.isStringLike credential then
        with lists.findSingle ({ value, ... }: strings.isStringLike value)
          (throw "Credential option must be given")
          (throw "Credential option must be singular")
          (attrsets.mapAttrsToList attrsets.nameValuePair credential);
        {
          id = builtins.head (builtins.split ":" "${value}");
          serviceConfig.${name} = "${value}";
        }
      else if strings.hasInfix ":" "${credential}" then
        {
          id = builtins.head (builtins.split ":" "${credential}");
          serviceConfig.LoadCredentialEncrypted = "${credential}";
        }
      else
        {
          id = defaultId;
          serviceConfig.LoadCredential = "${defaultId}:${credential}";
        }
    );
    {
      inherit id;
      serviceConfig = serviceConfig // {
        BindPaths = if bindPath != null then [ "%d/${id}:${bindPath}" ] else [ ];
      };
    };
}
