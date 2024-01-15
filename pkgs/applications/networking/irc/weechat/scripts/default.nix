{ callPackage, luaPackages, perlPackages, python3Packages }:

{
  colorize_nicks = callPackage ./colorize_nicks { };

  edit = callPackage ./edit { };

  multiline = callPackage ./multiline {
    inherit (perlPackages) PodParser;
  };

  url_hint = callPackage ./url_hint { };

  weechat-grep = callPackage ./weechat-grep { };

  weechat-matrix-bridge = callPackage ./weechat-matrix-bridge {
    inherit (luaPackages) cjson luaffi;
  };

  weechat-matrix = python3Packages.callPackage ./weechat-matrix { };

  weechat-notify-send = python3Packages.callPackage ./weechat-notify-send { };

  wee-slack = callPackage ./wee-slack { };

  weechat-autosort = callPackage ./weechat-autosort { };

  weechat-otr = callPackage ./weechat-otr { };

  weechat-go = callPackage ./weechat-go { };

  buffer_autoset = callPackage ./buffer_autoset { };

  highmon = callPackage ./highmon { };

  zncplayback = callPackage ./zncplayback { };
}
