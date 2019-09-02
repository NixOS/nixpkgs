{ callPackage, luaPackages, python3Packages }:

{
  autojoin = callPackage ./autojoin { };

  wee-slack = callPackage ./wee-slack { };

  weechat-autosort = callPackage ./weechat-autosort { };

  weechat-matrix = python3Packages.callPackage ./weechat-matrix { };

  weechat-matrix-bridge = callPackage ./weechat-matrix-bridge {
    inherit (luaPackages) cjson luaffi;
  };

  weechat-otr = callPackage ./weechat-otr { };
}
