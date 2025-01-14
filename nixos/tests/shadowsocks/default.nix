{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  "basic" = import ./common.nix {
    name = "basic";
  };

  "v2ray-plugin" = import ./common.nix {
    name = "v2ray-plugin";
    plugin = "${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
    pluginOpts = "host=nixos.org";
  };
}
