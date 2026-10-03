{ config, lib }:
let
  inherit (lib)
    zipListsWith
    optionalString
    concatMapStrings
    concatMapStringsSep
    ;
  cfg = config.services.xserver.windowManager.dwm.config;
  boolToString = x: if x then "1" else "0";
  modToString = modifier: if (modifier != null) then (toString modifier) else "MODIFIER";
in
/* c */ ''
  ${cfg.file.prepend}
  static const unsigned int borderpx = ${toString cfg.borderpx};
  static const unsigned int snap     = ${toString cfg.snap};
  static const int showbar           = ${boolToString cfg.showBar};
  static const int topbar            = ${boolToString cfg.topBar};
  static const char *fonts[]         = { "${cfg.font.name}:size=${toString cfg.font.size}" };
  static const char *colors[][3] = {
  ${concatMapStringsSep "," (
    scheme: ''[${scheme.name}]={"${scheme.fg}", "${scheme.bg}", "${scheme.border}"}''
  ) cfg.colors}
  };

  static const char *tags[] = { ${concatMapStringsSep ", " (tag: ''"${toString tag}"'') cfg.tags} };

  static const Rule rules[] = {
  ${
    let
      valueToString = val: if val != null then ''"${toString val}"'' else "NULL";
    in
    concatMapStringsSep ", " (rule: ''
      {
      "${rule.class}", ${valueToString rule.instance}, ${valueToString rule.title}, ${
        if (rule.tag != null) then "1<<${toString (rule.tag - 1)}" else "0"
      }, ${boolToString rule.isFloating}, ${toString rule.monitor}
      }
    '') cfg.rules
  }
  };

  static const float mfact        = ${toString cfg.layout.mfact};
  static const int nmaster        = ${toString cfg.layout.nmaster};
  static const int resizehints    = ${boolToString cfg.layout.resizehints};
  static const int lockfullscreen = ${boolToString cfg.layout.lockfullscreen};
  static const int refreshrate

  static const Layout layouts[] = {
  ${concatMapStringsSep ",\n " (
    layout: ''{"${layout.symbol}", ${layout.arrangeFunction}}''
  ) cfg.layout.layouts}
  };

  #define MODKEY ${cfg.modifier}
  #define TAGKEYS(KEY, TAG) \
      {${cfg.tagKeys.modifiers.viewOnlyThisTag},       KEY, view,       {.ui = 1 << TAG} }, \
      {${cfg.tagKeys.modifiers.toggleThisTagInView},   KEY, toggleview, {.ui = 1 << TAG} }, \
      {${cfg.tagKeys.modifiers.moveWindowToThisTag},   KEY, tag,        {.ui = 1 << TAG} }, \
      {${cfg.tagKeys.modifiers.toggleWindowOnThisTag}, KEY, toggletag,  {.ui = 1 << TAG} },

  #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

  static char dmenumon[2] = "0";
  ${
    let
      createAppCmd = attrSet: ''
        { "${attrSet.appCmd}",
            ${optionalString (attrSet.appArgs != [ ] && attrSet.appArgs != null) (
              concatMapStringsSep " " (
                arg: ''"${toString arg.flag}"${optionalString (arg.argument != null) ", ${arg.argument}"},''
              ) attrSet.appArgs
            )}
            NULL };'';
    in
    concatMapStrings (
      zipListsWith (keys: name: ''static const char *${name}[] = ${createAppCmd keys}'')
        [ cfg.appLauncher cfg.terminal ]
        [ "dmenucmd" "termcmd" ]
    )
  }

  static const Key keys[] = {
      {
        ${
          # create default key bindings before user defined bindings, key-binds use the first defined in dwm.
          optionalString cfg.key.useDefault /* c */ ''
              { MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
            	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
            	{ MODKEY,                       XK_b,      togglebar,      {0} },
            	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
            	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
            	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
            	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
            	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
            	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
            	{ MODKEY,                       XK_Return, zoom,           {0} },
            	{ MODKEY,                       XK_Tab,    view,           {0} },
            	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
            	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
            	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
            	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
            	{ MODKEY,                       XK_space,  setlayout,      {0} },
            	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
            	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
            	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
            	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
            	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
            	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
            	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
            	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },

          ''
        }
      ${
        # create tag keys bindings these should also not be overridden by user keybindings
        concatMapStringsSep ", " (tag: "TAGKEYS(${tag.key}, ${toString tag.tag})") cfg.tagKeys.definitions
      }
      ${
        let
          # generate keybindings for the terminal and app launcher
          appKeys = zipListsWith (key: cmd: {
            modifier = modToString key.modifier;
            key = key.launchKey;
            function = "spawn";
            argument = "{.v=${cmd}}";
          }) [ cfg.terminal cfg.appLauncher ] [ "termcmd" "dmenucmd" ];
        in
        concatMapStringsSep "," (
          key: "{${modToString key.modifier}, ${key.key}, ${key.function}, ${key.argument} }"
        ) (appKeys ++ cfg.key.keys)
      },
  };

  static const Button buttons[] = {
      ${optionalString cfg.buttons.useDefault /* c */ ''
        { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
        { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
        { ClkWinTitle,          0,              Button2,        zoom,           {0} },
        { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
        { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
        { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
        { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
        { ClkTagBar,            0,              Button1,        view,           {0} },
        { ClkTagBar,            0,              Button3,        toggleview,     {0} },
        { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
        { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
      ''}
      ${
        concatMapStringsSep ", " (
          button:
          "{${button.clickArea},${button.modifier},${button.button},${button.function},${button.argument}}"
        ) cfg.buttons.binds
      },
  };

  ${cfg.file.append}
''
