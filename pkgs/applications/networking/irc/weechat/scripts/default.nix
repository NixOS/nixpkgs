{ callPackage, luaPackages, python3Packages }:

{
  weechat-matrix-bridge = callPackage ./weechat-matrix-bridge {
    inherit (luaPackages) cjson luaffi;
  };

  weechat-matrix = python3Packages.callPackage ./weechat-matrix { };

  wee-slack = callPackage ./wee-slack { };

  weechat-autosort = callPackage ./weechat-autosort { };

  weechat-otr = callPackage ./weechat-otr { };
}
