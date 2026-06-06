{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  "basic-rust" = import ./common.nix {
    name = "basic-rust";
    package = pkgs.shadowsocks-rust;
  };

  "v2ray-plugin-rust" = import ./common.nix {
    name = "v2ray-plugin-rust";
    package = pkgs.shadowsocks-rust;
    plugin = "${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
    pluginOpts = "host=nixos.org";
  };
}
