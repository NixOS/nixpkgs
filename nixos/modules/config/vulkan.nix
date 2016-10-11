{ config, lib, pkgs, ... }:

with lib;

let

  layers = [
    "core_validation"
    "image"
    "object_tracker"
    "parameter_validation"
    "swapchain"
    "threading"
    "unique_objects"
  ];

  inherit (pkgs) vulkan-loader;

in

{
  options = {
    vulkan.validation = mkOption {
      type = types.bool;
      default = false;
      description = "When enabled, the validation layers from the vulkan SDK are installed";
    };
  };

  config = mkIf config.vulkan.validation {
    environment.systemPackages = [ vulkan-loader ];
    environment.etc = listToAttrs (map
      (n: nameValuePair ("vulkan/explicit_layer.d/VkLayer_${n}.json") {
        source = vulkan-loader + "/etc/explicit_layer.d/VkLayer_${n}.json";
      })
      layers);
  };
}
