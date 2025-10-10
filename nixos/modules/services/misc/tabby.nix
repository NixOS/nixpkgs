{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types mkRemovedOptionModule;

  cfg = config.services.tabby;
  format = pkgs.formats.toml { };
  tabbyPackage = cfg.package.override {
    inherit (cfg) acceleration;
  };
in
{
  imports = [
    (mkRemovedOptionModule [
      "services"
      "tabby"
      "indexInterval"
    ] "These options are now managed within the tabby WebGUI")
  ];
  options = {
    services.tabby = {
      enable = lib.mkEnableOption "Self-hosted AI coding assistant using large language models";

      package = lib.mkPackageOption pkgs "tabby" { };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          Specifies the hostname on which the tabby server HTTP interface listens.
        '';
      };

      port = lib.mkOption {
        type = types.port;
        default = 11029;
        description = ''
          Specifies the bind port on which the tabby server HTTP interface listens.
        '';
      };

      model = lib.mkOption {
        type = types.str;
        default = "TabbyML/StarCoder-1B";
        description = ''
          Specify the model that tabby will use to generate completions.

          This model will be downloaded automatically if it is not already present.

          If you want to utilize an existing model that you've already
          downloaded you'll need to move it into tabby's state directory which
          lives in `/var/lib/tabby`. Because the tabby.service is configured to
          use a DynamicUser the service will need to have been started at least
          once before you can move the locally existing model into
          `/var/lib/tabby`. You can set the model to 'none' and tabby will
          startup and fail to download a model, but will have created the
          `/var/lib/tabby` directory. You can then copy over the model manually
          into `/var/lib/tabby`, update the model option to the name you just
          downloaded and copied over then `nixos-rebuild switch` to start using
          it.

          $ tabby download --model TabbyML/DeepseekCoder-6.7B
          $ find ~/.tabby/ | tail -n1
          /home/ghthor/.tabby/models/TabbyML/DeepseekCoder-6.7B/ggml/q8_0.v2.gguf
          $ sudo rsync -r ~/.tabby/models/ /var/lib/tabby/models/
          $ sudo chown -R tabby:tabby /var/lib/tabby/models/

          See for Model Options:
          > <https://github.com/TabbyML/registry-tabby>
        '';
      };

      acceleration = lib.mkOption {
        type = types.nullOr (
          types.enum [
            "cpu"
            "rocm"
            "cuda"
            "metal"
          ]
        );
        default = null;
        example = "rocm";
        description = ''
          Specifies the device to use for hardware acceleration.

          -   `cpu`: no acceleration just use the CPU
          -  `rocm`: supported by modern AMD GPUs
          -  `cuda`: supported by modern NVIDIA GPUs
          - `metal`: supported on darwin aarch64 machines

          Tabby will try and determine what type of acceleration that is
          already enabled in your configuration when `acceleration = null`.

          - nixpkgs.config.cudaSupport
          - nixpkgs.config.rocmSupport
          - if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64

          IFF multiple acceleration methods are found to be enabled or if you
          haven't set either `cudaSupport or rocmSupport` you will have to
          specify the device type manually here otherwise it will default to
          the first from the list above or to cpu.
        '';
      };

      usageCollection = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable sending anonymous usage data.

          See for more details:
          > <https://tabby.tabbyml.com/docs/configuration#usage-collection>
        '';
      };
    };
  };

  # TODO(ghthor): firewall config

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ tabbyPackage ];
    };

    systemd =
      let
        serviceUser = {
          WorkingDirectory = "/var/lib/tabby";
          StateDirectory = [ "tabby" ];
          ConfigurationDirectory = [ "tabby" ];
          DynamicUser = true;
          User = "tabby";
          Group = "tabby";
        };

        serviceEnv = lib.mkMerge [
          {
            TABBY_ROOT = "%S/tabby";
          }
          (lib.mkIf (!cfg.usageCollection) {
            TABBY_DISABLE_USAGE_COLLECTION = "1";
          })
        ];
      in
      {
        services.tabby = {
          wantedBy = [ "multi-user.target" ];
          description = "Self-hosted AI coding assistant using large language models";
          after = [ "network.target" ];
          environment = serviceEnv;
          serviceConfig = lib.mkMerge [
            serviceUser
            {
              ExecStart = "${lib.getExe tabbyPackage} serve --model ${cfg.model} --host ${cfg.host} --port ${toString cfg.port} --device ${tabbyPackage.featureDevice}";
            }
          ];
        };
      };
  };

  meta.maintainers = with lib.maintainers; [ ghthor ];
}
