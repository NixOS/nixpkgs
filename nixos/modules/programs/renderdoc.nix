{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.renderdoc;
  layerDir = "${cfg.package}/share/vulkan/implicit_layer.d";
in
{
  options.programs.renderdoc = {
    enable = lib.mkEnableOption "RenderDoc a frame-capture based graphics debugger";

    package = lib.mkPackageOption pkgs "renderdoc" {
      example = "renderdoc";
    };

    installVulkanLayer = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Installs the Vulkan layer for RenderDoc,
        which is required for Vulkan applications to be captured.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc = lib.mkIf cfg.installVulkanLayer (
      assert lib.assertMsg (cfg.package ? passthru.vulkanLayers) ''
        programs.renderdoc.package (${cfg.package.name or "renderdoc"}) does not
        expose `passthru.vulkanLayers`, which is required to install the Vulkan
        implicit layer manifest(s) to /etc/vulkan/implicit_layer.d.
        Either use the upstream `renderdoc` package, add
        `passthru.vulkanLayers` to your override, or set
        `programs.renderdoc.installVulkanLayer = false;`.
      '';
      lib.listToAttrs (
        map (name: {
          name = "vulkan/implicit_layer.d/${name}";
          value = {
            source = "${layerDir}/${name}";
          };
        }) cfg.package.passthru.vulkanLayers
      )
    );
  };

  meta.maintainers = with lib.maintainers; [
    ShyAssassin
    pbsds
  ];
}
