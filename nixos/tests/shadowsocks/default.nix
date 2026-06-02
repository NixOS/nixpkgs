{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  "basic-libev" = import ./common.nix {
    name = "basic-libev";
    package = pkgs.shadowsocks-libev;
  };

  "basic-rust" = import ./common.nix {
    name = "basic-rust";
    package = pkgs.shadowsocks-rust;
  };

  "v2ray-plugin-libev" = import ./common.nix {
    name = "v2ray-plugin-libev";
    package = pkgs.shadowsocks-libev;
    plugin = "${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
    pluginOpts = "host=nixos.org";
  };

  "v2ray-plugin-rust" = import ./common.nix {
    name = "v2ray-plugin-rust";
    package = pkgs.shadowsocks-rust;
    plugin = "${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
    pluginOpts = "host=nixos.org";
  };
}
