{ config, lib, pkgs, ... }:
let
  cfg = config.services.step-ca;
  settingsFormat = (pkgs.formats.json { });
in
{
  meta.maintainers = with lib.maintainers; [ mohe2015 ];

  options = {
    services.step-ca = {
      enable = lib.mkEnableOption "the smallstep certificate authority server";
      openFirewall = lib.mkEnableOption "opening the certificate authority server port";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.step-ca;
        defaultText = lib.literalExpression "pkgs.step-ca";
        description = lib.mdDoc "Which step-ca package to use.";
      };
      address = lib.mkOption {
        type = lib.types.str;
        example = "127.0.0.1";
        description = lib.mdDoc ''
          The address (without port) the certificate authority should listen at.
          This combined with {option}`services.step-ca.port` overrides {option}`services.step-ca.settings.address`.
        '';
      };
      port = lib.mkOption {
        type = lib.types.port;
        example = 8443;
        description = lib.mdDoc ''
          The port the certificate authority should listen on.
          This combined with {option}`services.step-ca.address` overrides {option}`services.step-ca.settings.address`.
        '';
      };
      settings = lib.mkOption {
        type = with lib.types; attrsOf anything;
        description = ''
          Settings that go into <filename>ca.json</filename>. See
          <link xlink:href="https://smallstep.com/docs/step-ca/configuration">the step-ca manual</link>
          for more information. The easiest way to
          configure this module would be to run <literal>step ca init</literal>
          to generate <filename>ca.json</filename> and then import it using
          <literal>builtins.fromJSON</literal>.
          <link xlink:href="https://smallstep.com/docs/step-cli/basic-crypto-operations#run-an-offline-x509-certificate-authority">This article</link>
          may also be useful if you want to customize certain aspects of
          certificate generation for your CA.
          You need to change the database storage path to <filename>/var/lib/step-ca/db</filename>.

          <warning>
            <para>
              The <option>services.step-ca.settings.address</option> option
              will be ignored and overwritten by
              <option>services.step-ca.address</option> and
              <option>services.step-ca.port</option>.
            </para>
          </warning>
        '';
      };
      intermediatePasswordFile = lib.mkOption {
        type = lib.types.path;
        example = "/run/keys/smallstep-password";
        description = ''
          Path to the file containing the password for the intermediate
          certificate private key.

          <warning>
            <para>
              Make sure to use a quoted absolute path instead of a path literal
              to prevent it from being copied to the globally readable Nix
              store.
            </para>
          </warning>
        '';
      };
    };
  };

  config = lib.mkIf config.services.step-ca.enable (
    let
      configFile = settingsFormat.generate "ca.json" (cfg.settings // {
        address = cfg.address + ":" + toString cfg.port;
      });
    in
    {
      assertions =
        [
          {
            assertion = !lib.isStorePath cfg.intermediatePasswordFile;
            message = ''
              <option>services.step-ca.intermediatePasswordFile</option> points to
              a file in the Nix store. You should use a quoted absolute path to
              prevent this.
            '';
          }
        ];

      systemd.packages = [ cfg.package ];

      # configuration file indirection is needed to support reloading
      environment.etc."smallstep/ca.json".source = configFile;

      systemd.services."step-ca" = {
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ configFile ];
        unitConfig = {
          ConditionFileNotEmpty = ""; # override upstream
        };
        serviceConfig = {
          User = "step-ca";
          Group = "step-ca";
          UMask = "0077";
          Environment = "HOME=%S/step-ca";
          WorkingDirectory = ""; # override upstream
          ReadWriteDirectories = ""; # override upstream

          # LocalCredential handles file permission problems arising from the use of DynamicUser.
          LoadCredential = "intermediate_password:${cfg.intermediatePasswordFile}";

          ExecStart = [
            "" # override upstream
            "${cfg.package}/bin/step-ca /etc/smallstep/ca.json --password-file \${CREDENTIALS_DIRECTORY}/intermediate_password"
          ];

          # ProtectProc = "invisible"; # not supported by upstream yet
          # ProcSubset = "pid"; # not supported by upstream yet
          # PrivateUsers = true; # doesn't work with privileged ports therefore not supported by upstream

          DynamicUser = true;
          StateDirectory = "step-ca";
        };
      };

      users.users.step-ca = {
        home = "/var/lib/step-ca";
        group = "step-ca";
        isSystemUser = true;
      };

      users.groups.step-ca = {};

      networking.firewall = lib.mkIf cfg.openFirewall {
        allowedTCPPorts = [ cfg.port ];
      };
    }
  );
}
