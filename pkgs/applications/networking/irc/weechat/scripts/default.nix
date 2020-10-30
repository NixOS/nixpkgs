{ callPackage, luaPackages, python3Packages }:

{
  weechat-matrix-bridge = callPackage ./weechat-matrix-bridge {
    inherit (luaPackages) cjson luaffi;
  };

  weechat-matrix = python3Packages.callPackage ./weechat-matrix { };

  weechat-notify-send = python3Packages.callPackage ./weechat-notify-send { };

  wee-slack = callPackage ./wee-slack { };

  weechat-autosort = callPackage ./weechat-autosort { };

  weechat-otr = callPackage ./weechat-otr { };
}
