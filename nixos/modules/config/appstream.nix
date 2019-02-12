{ config, lib, ... }:

with lib;
{
  options = {
    appstream.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the 
        <link xlink:href="https://www.freedesktop.org/software/appstream/docs/index.html">AppStream metadata specification</link>.
      '';
    };
  };

  config = mkIf config.appstream.enable {
    environment.pathsToLink = [ 
      # per component metadata
      "/share/metainfo" 
      # legacy path for above
      "/share/appdata" 
    ];
  };

}
