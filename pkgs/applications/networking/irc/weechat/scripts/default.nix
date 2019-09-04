{ callPackage, luaPackages }:

{
  weechat-xmpp = callPackage ./weechat-xmpp {
    inherit (pythonPackages) pydns;
  };

  weechat-matrix-bridge = callPackage ./weechat-matrix-bridge {
    inherit (luaPackages) cjson luaffi;
  };

  wee-slack = callPackage ./wee-slack { };

  weechat-autosort = callPackage ./weechat-autosort { };

  weechat-otr = callPackage ./weechat-otr { };
}
