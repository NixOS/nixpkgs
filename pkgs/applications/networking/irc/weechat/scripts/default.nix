{ callPackage, luaPackages, python2Packages }:

{
  weechat-xmpp = callPackage ./weechat-xmpp {
    inherit (python2Packages) pydns;
  };

  weechat-matrix-bridge = callPackage ./weechat-matrix-bridge {
    inherit (luaPackages) cjson;
  };

  wee-slack = callPackage ./wee-slack {
    inherit python2Packages;
  };

  weechat-autosort = callPackage ./weechat-autosort { };
}
