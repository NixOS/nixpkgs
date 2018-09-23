{ callPackage, luaPackages, pythonPackages }:

{
  weechat-xmpp = callPackage ./weechat-xmpp {
    inherit (pythonPackages) pydns;
  };

  weechat-matrix-bridge = callPackage ./weechat-matrix-bridge {
    inherit (luaPackages) cjson;
  };

  wee-slack = callPackage ./wee-slack { };
}
