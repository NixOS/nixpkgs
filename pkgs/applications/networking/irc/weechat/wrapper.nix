let
  weechatDefault = "$HOME/.weechat";
in
  { weechat, plugins ? {}, buildFHSUserEnv
  , homeDir ? weechatDefault, term ? "xterm" }:

  let
    weechat' =
      if homeDir == weechatDefault
      then weechat
      else weechat.override { inherit homeDir; };

    termScript = ''
      export TERM=${term}
    '';

    pluginScripts = map (a: ''
      mkdir -p ${homeDir}/$(dirname ${a})
      cp -f ${plugins."${a}"}/share/$(basename ${a}) ${homeDir}/${a}
    '') (builtins.attrNames plugins);
  in
    buildFHSUserEnv {
      name = "weechat-wrapper";

      targetPkgs = (_: [ weechat' ] ++ (builtins.attrValues plugins));
      runScript = "${weechat'}/bin/weechat";

      profile = builtins.concatStringsSep "\n" ([ termScript ] ++ pluginScripts);
    }
