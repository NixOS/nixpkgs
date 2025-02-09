/*
  Manages /etc/nix.conf.

  See also
   - ./nix-channel.nix
   - ./nix-flakes.nix
   - ./nix-remote-build.nix
   - nixos/modules/services/system/nix-daemon.nix
 */
{ config, lib, pkgs, ... }:

let
  inherit (lib)
    concatStringsSep
    boolToString
    escape
    floatToString
    getVersion
    isBool
    isDerivation
    isFloat
    isInt
    isList
    isString
    literalExpression
    mapAttrsToList
    mkAfter
    mkDefault
    mkIf
    mkOption
    mkRenamedOptionModuleWith
    optionalString
    optionals
    strings
    systems
    toPretty
    types
    versionAtLeast
    ;

  cfg = config.nix;

  nixPackage = cfg.package.out;

  isNixAtLeast = versionAtLeast (getVersion nixPackage);

  legacyConfMappings = {
    useSandbox = "sandbox";
    buildCores = "cores";
    maxJobs = "max-jobs";
    sandboxPaths = "extra-sandbox-paths";
    binaryCaches = "substituters";
    trustedBinaryCaches = "trusted-substituters";
    binaryCachePublicKeys = "trusted-public-keys";
    autoOptimiseStore = "auto-optimise-store";
    requireSignedBinaryCaches = "require-sigs";
    trustedUsers = "trusted-users";
    allowedUsers = "allowed-users";
    systemFeatures = "system-features";
  };

  semanticConfType = with types;
    let
      confAtom = nullOr
        (oneOf [
          bool
          int
          float
          str
          path
          package
        ]) // {
        description = "Nix config atom (null, bool, int, float, str, path or package)";
      };
    in
    attrsOf (either confAtom (listOf confAtom));

  nixConf =
    assert isNixAtLeast "2.2";
    let

      mkValueString = v:
        if v == null then ""
        else if isInt v then toString v
        else if isBool v then boolToString v
        else if isFloat v then floatToString v
        else if isList v then toString v
        else if isDerivation v then toString v
        else if builtins.isPath v then toString v
        else if isString v then v
        else if strings.isConvertibleWithToString v then toString v
        else abort "The nix conf value: ${toPretty {} v} can not be encoded";

      mkKeyValue = k: v: "${escape [ "=" ] k} = ${mkValueString v}";

      mkKeyValuePairs = attrs: concatStringsSep "\n" (mapAttrsToList mkKeyValue attrs);

    in
    pkgs.writeTextFile {
      name = "nix.conf";
      text = ''
        # WARNING: this file is generated from the nix.* options in
        # your NixOS configuration, typically
        # /etc/nixos/configuration.nix.  Do not edit it!
        ${mkKeyValuePairs cfg.settings}
        ${cfg.extraOptions}
      '';
      checkPhase = lib.optionalString cfg.checkConfig (
        if pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform then ''
          echo "Ignoring validation for cross-compilation"
        ''
        else
        let
          showCommand = if isNixAtLeast "2.20pre" then "config show" else "show-config";
        in
        ''
          echo "Validating generated nix.conf"
          ln -s $out ./nix.conf
          set -e
          set +o pipefail
          NIX_CONF_DIR=$PWD \
            ${cfg.package}/bin/nix ${showCommand} ${optionalString (isNixAtLeast "2.3pre") "--no-net"} \
              ${optionalString (isNixAtLeast "2.4pre") "--option experimental-features nix-command"} \
            |& sed -e 's/^warning:/error:/' \
            | (! grep '${if cfg.checkAllErrors then "^error:" else "^error: unknown setting"}')
          set -o pipefail
        '');
    };

in
{
  imports = [
    (mkRenamedOptionModuleWith { sinceRelease = 2003; from = [ "nix" "useChroot" ]; to = [ "nix" "useSandbox" ]; })
    (mkRenamedOptionModuleWith { sinceRelease = 2003; from = [ "nix" "chrootDirs" ]; to = [ "nix" "sandboxPaths" ]; })
  ] ++
    mapAttrsToList
      (oldConf: newConf:
        mkRenamedOptionModuleWith {
          sinceRelease = 2205;
          from = [ "nix" oldConf ];
          to = [ "nix" "settings" newConf ];
      })
      legacyConfMappings;

  options = {
    nix = {
      checkConfig = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          If enabled, checks that Nix can parse the generated nix.conf.
        '';
      };

      checkAllErrors = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          If enabled, checks the nix.conf parsing for any kind of error. When disabled, checks only for unknown settings.
        '';
      };

      extraOptions = mkOption {
        type = types.lines;
        default = "";
        example = ''
          keep-outputs = true
          keep-derivations = true
        '';
        description = lib.mdDoc "Additional text appended to {file}`nix.conf`.";
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = semanticConfType;

          options = {
            max-jobs = mkOption {
              type = types.either types.int (types.enum [ "auto" ]);
              default = "auto";
              example = 64;
              description = lib.mdDoc ''
                This option defines the maximum number of jobs that Nix will try to
                build in parallel. The default is auto, which means it will use all
                available logical cores. It is recommend to set it to the total
                number of logical cores in your system (e.g., 16 for two CPUs with 4
                cores each and hyper-threading).
              '';
            };

            auto-optimise-store = mkOption {
              type = types.bool;
              default = false;
              example = true;
              description = lib.mdDoc ''
                If set to true, Nix automatically detects files in the store that have
                identical contents, and replaces them with hard links to a single copy.
                This saves disk space. If set to false (the default), you can still run
                nix-store --optimise to get rid of duplicate files.
              '';
            };

            cores = mkOption {
              type = types.int;
              default = 0;
              example = 64;
              description = lib.mdDoc ''
                This option defines the maximum number of concurrent tasks during
                one build. It affects, e.g., -j option for make.
                The special value 0 means that the builder should use all
                available CPU cores in the system. Some builds may become
                non-deterministic with this option; use with care! Packages will
                only be affected if enableParallelBuilding is set for them.
              '';
            };

            sandbox = mkOption {
              type = types.either types.bool (types.enum [ "relaxed" ]);
              default = true;
              description = lib.mdDoc ''
                If set, Nix will perform builds in a sandboxed environment that it
                will set up automatically for each build. This prevents impurities
                in builds by disallowing access to dependencies outside of the Nix
                store by using network and mount namespaces in a chroot environment.

                This is enabled by default even though it has a possible performance
                impact due to the initial setup time of a sandbox for each build. It
                doesn't affect derivation hashes, so changing this option will not
                trigger a rebuild of packages.

                When set to "relaxed", this option permits derivations that set
                `__noChroot = true;` to run outside of the sandboxed environment.
                Exercise caution when using this mode of operation! It is intended to
                be a quick hack when building with packages that are not easily setup
                to be built reproducibly.
              '';
            };

            extra-sandbox-paths = mkOption {
              type = types.listOf types.str;
              default = [ ];
              example = [ "/dev" "/proc" ];
              description = lib.mdDoc ''
                Directories from the host filesystem to be included
                in the sandbox.
              '';
            };

            substituters = mkOption {
              type = types.listOf types.str;
              description = lib.mdDoc ''
                List of binary cache URLs used to obtain pre-built binaries
                of Nix packages.

                By default https://cache.nixos.org/ is added.
              '';
            };

            trusted-substituters = mkOption {
              type = types.listOf types.str;
              default = [ ];
              example = [ "https://hydra.nixos.org/" ];
              description = lib.mdDoc ''
                List of binary cache URLs that non-root users can use (in
                addition to those specified using
                {option}`nix.settings.substituters`) by passing
                `--option binary-caches` to Nix commands.
              '';
            };

            require-sigs = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                If enabled (the default), Nix will only download binaries from binary caches if
                they are cryptographically signed with any of the keys listed in
                {option}`nix.settings.trusted-public-keys`. If disabled, signatures are neither
                required nor checked, so it's strongly recommended that you use only
                trustworthy caches and https to prevent man-in-the-middle attacks.
              '';
            };

            trusted-public-keys = mkOption {
              type = types.listOf types.str;
              example = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
              description = lib.mdDoc ''
                List of public keys used to sign binary caches. If
                {option}`nix.settings.trusted-public-keys` is enabled,
                then Nix will use a binary from a binary cache if and only
                if it is signed by *any* of the keys
                listed here. By default, only the key for
                `cache.nixos.org` is included.
              '';
            };

            trusted-users = mkOption {
              type = types.listOf types.str;
              default = [ "root" ];
              example = [ "root" "alice" "@wheel" ];
              description = lib.mdDoc ''
                A list of names of users that have additional rights when
                connecting to the Nix daemon, such as the ability to specify
                additional binary caches, or to import unsigned NARs. You
                can also specify groups by prefixing them with
                `@`; for instance,
                `@wheel` means all users in the wheel
                group.
              '';
            };

            system-features = mkOption {
              type = types.listOf types.str;
              example = [ "kvm" "big-parallel" "gccarch-skylake" ];
              description = lib.mdDoc ''
                The set of features supported by the machine. Derivations
                can express dependencies on system features through the
                `requiredSystemFeatures` attribute.

                By default, pseudo-features `nixos-test`, `benchmark`,
                and `big-parallel` used in Nixpkgs are set, `kvm`
                is also included if it is available.
              '';
            };

            allowed-users = mkOption {
              type = types.listOf types.str;
              default = [ "*" ];
              example = [ "@wheel" "@builders" "alice" "bob" ];
              description = lib.mdDoc ''
                A list of names of users (separated by whitespace) that are
                allowed to connect to the Nix daemon. As with
                {option}`nix.settings.trusted-users`, you can specify groups by
                prefixing them with `@`. Also, you can
                allow all users by specifying `*`. The
                default is `*`. Note that trusted users are
                always allowed to connect.
              '';
            };
          };
        };
        default = { };
        example = literalExpression ''
          {
            use-sandbox = true;
            show-trace = true;

            system-features = [ "big-parallel" "kvm" "recursive-nix" ];
            sandbox-paths = { "/bin/sh" = "''${pkgs.busybox-sandbox-shell.out}/bin/busybox"; };
          }
        '';
        description = lib.mdDoc ''
          Configuration for Nix, see
          <https://nixos.org/manual/nix/stable/command-ref/conf-file.html> or
          {manpage}`nix.conf(5)` for available options.
          The value declared here will be translated directly to the key-value pairs Nix expects.

          You can use {command}`nix-instantiate --eval --strict '<nixpkgs/nixos>' -A config.nix.settings`
          to view the current value. By default it is empty.

          Nix configurations defined under {option}`nix.*` will be translated and applied to this
          option. In addition, configuration specified in {option}`nix.extraOptions` will be appended
          verbatim to the resulting config file.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."nix/nix.conf".source = nixConf;
    nix.settings = {
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      substituters = mkAfter [ "https://cache.nixos.org/" ];
      system-features = mkDefault (
        [ "nixos-test" "benchmark" "big-parallel" "kvm" ] ++
        optionals (pkgs.stdenv.hostPlatform ? gcc.arch) (
          # a builder can run code for `gcc.arch` and inferior architectures
          [ "gccarch-${pkgs.stdenv.hostPlatform.gcc.arch}" ] ++
          map (x: "gccarch-${x}") (systems.architectures.inferiors.${pkgs.stdenv.hostPlatform.gcc.arch} or [])
        )
      );
    };
  };
}
