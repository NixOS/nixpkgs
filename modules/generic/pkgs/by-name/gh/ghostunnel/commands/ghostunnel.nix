# The options of `ghostunnel` that all of its subcommands share, in a module
# that is not specific to a module class. `ghostunnel` requires a subcommand,
# thus this module does not give a complete command line. The module of each
# subcommand, for example `ghostunnel/server.nix`, imports this module.
# `passthru.commandModules.ghostunnel` of `pkgs.ghostunnel` exposes it, thus a
# consumer can add a subcommand that does not have a module. See "Modules of a
# package" in the Nixpkgs manual for why it is in this directory.
#
# The consumer sets `package` and gives `assertions` and `warnings` to the root
# of its configuration. The consumer also gives the files in
# `credentials` to the program, for example as systemd credentials. Thus this
# module does not add them to `portable.argv`.

{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    filterAttrs
    getExe'
    mkBefore
    mkOption
    types
    ;
in
{
  imports = [
    # Not `lib.genericModules`: the `lib` module argument may come from a
    # different Nixpkgs version than this file.
    ../../../../../../../lib/modules/generic/assertions.nix
    (lib.modules.importApply ../../../../../../../lib/modules/generic/command-line.nix {
      prefix = [ "portable" ];
    })
  ];

  options = {
    package = mkOption {
      description = "Package to use for ghostunnel.";
      type = types.package;
    };

    keystore = mkOption {
      description = ''
        Path to keystore (combined PEM with cert/key, or PKCS12 keystore).

        NB: storepass is not supported because it would expose credentials via `/proc/*/cmdline`.

        Specify this or `cert` and `key`.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    cert = mkOption {
      description = ''
        Path to certificate (PEM with certificate chain).

        Not required if `keystore` is set.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    key = mkOption {
      description = ''
        Path to certificate private key (PEM with private key).

        Not required if `keystore` is set.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    cacert = mkOption {
      description = ''
        Path to CA bundle file (PEM/X509). Uses system trust store if `null`.
      '';
      type = types.nullOr types.str;
    };

    credentials = mkOption {
      description = ''
        Files to give to the program, by the name of the flag.
        For each `name = path`, the consumer makes `path` available to the
        program and adds `--name=<location>` to the command line.

        This option is set from `keystore`, `cert`, `key` and `cacert`.
      '';
      type = types.attrsOf types.str;
      readOnly = true;
      internal = true;
    };
  };

  config = {
    credentials = filterAttrs (_: path: path != null) {
      inherit (config)
        keystore
        cert
        key
        cacert
        ;
    };

    portable.executable = getExe' config.package "ghostunnel";

    # The flags of `ghostunnel` come before the subcommand.
    portable.argv = mkBefore [
      # ghostunnel's landlock rules don't like reading the CA certs from /etc
      # because they are links to /nix/store, which isn't part of its rules
      "--disable-landlock"
    ];
  };
}
