{ config, lib }:
with lib;
let
  defaultKeys = [
    {
      modifier = "MODKEY";
      key = "XK_b";
      function = "togglebar";
      argument = "{0}";
    }
    {
      modifier = "MODKEY";
      key = "XK_j";
      function = "focusstack";
      argument = "{.i = +1 }";
    }
    {
      modifier = "MODKEY";
      key = "XK_k";
      function = "focusstack";
      argument = "{.i = -1 }";
    }
    {
      modifier = "MODKEY";
      key = "XK_i";
      function = "incnmaster";
      argument = "{.i = +1 }";
    }
    {
      modifier = "MODKEY";
      key = "XK_d";
      function = "incnmaster";
      argument = "{.i = -1 }";
    }
    {
      modifier = "MODKEY";
      key = "XK_h";
      function = "setmfact";
      argument = "{.f = -0.05}";
    }
    {
      modifier = "MODKEY";
      key = "XK_l";
      function = "setmfact";
      argument = "{.f = +0.05}";
    }
    {
      modifier = "MODKEY";
      key = "XK_Return";
      function = "zoom";
      argument = "{0}";
    }
    {
      modifier = "MODKEY";
      key = "XK_Tab";
      function = "view";
      argument = "{0}";
    }
    {
      modifier = "MODKEY|ShiftMask";
      key = "XK_c";
      function = "killclient";
      argument = "{0}";
    }
    {
      modifier = "MODKEY";
      key = "XK_t";
      function = "setlayout";
      argument = "{.v = &layouts[0]}";
    }
    {
      modifier = "MODKEY";
      key = "XK_f";
      function = "setlayout";
      argument = "{.v = &layouts[1]}";
    }
    {
      modifier = "MODKEY";
      key = "XK_m";
      function = "setlayout";
      argument = "{.v = &layouts[2]}";
    }
    {
      modifier = "MODKEY";
      key = "XK_space";
      function = "setlayout";
      argument = "{0}";
    }
    {
      modifier = "MODKEY|ShiftMask";
      key = "XK_space";
      function = "togglefloating";
      argument = "{0}";
    }
    {
      modifier = "MODKEY";
      key = "XK_0";
      function = "view";
      argument = "{.ui = ~0 }";
    }
    {
      modifier = "MODKEY|ShiftMask";
      key = "XK_0";
      function = "tag";
      argument = "{.ui = ~0 }";
    }
    {
      modifier = "MODKEY";
      key = "XK_comma";
      function = "focusmon";
      argument = "{.i = -1 }";
    }
    {
      modifier = "MODKEY";
      key = "XK_period";
      function = "focusmon";
      argument = "{.i = +1 }";
    }
    {
      modifier = "MODKEY|ShiftMask";
      key = "XK_comma";
      function = "tagmon";
      argument = "{.i = -1 }";
    }
    {
      modifier = "MODKEY|ShiftMask";
      key = "XK_period";
      function = "tagmon";
      argument = "{.i = +1 }";
    }
    {
      modifier = "MODKEY|ShiftMask";
      key = "XK_q";
      function = "quit";
      argument = "{0}";
    }
  ];
  cfg = config.programs.dwm;
in
/* c */ ''
  ${cfg.file.prepend}
  #define MODKEY ${cfg.modifier}
  #define TAGKEYS(KEY, TAG) \
      {${cfg.tagKeys.modifiers.viewOnlyThisTag},       KEY, view,       {.ui = 1 << TAG} }, \
      {${cfg.tagKeys.modifiers.toggleThisTagInView},   KEY, toggleview, {.ui = 1 << TAG} }, \
      {${cfg.tagKeys.modifiers.moveWindowToThisTag},   KEY, tag,        {.ui = 1 << TAG} }, \
      {${cfg.tagKeys.modifiers.toggleWindowOnThisTag}, KEY, toggletag,  {.ui = 1 << TAG} },
  #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
  static const unsigned int borderpx = ${toString cfg.borderpx};
  static const unsigned int gappx    = ${toString cfg.patches.gaps.width};
  static const unsigned int snap     = ${toString cfg.snap};
  static const int showbar           = ${if cfg.showBar then "1" else "0"};
  static const int topbar            = ${if cfg.topBar then "1" else "0"};
  static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
  static const char *fonts[]         = { "${cfg.font.name}:size=${toString cfg.font.size}" };

  /* layout(s) */
  static const float mfact        = ${toString cfg.layout.mfact}; /* factor of master area size [0.05..0.95] */
  static const int nmaster        = ${toString cfg.layout.nmaster};    /* number of clients in master area */
  static const int resizehints    = ${toString cfg.layout.resizehints};    /* 1 means respect size hints in tiled resizals */
  static const int lockfullscreen = ${toString cfg.layout.lockfullscreen}; /* 1 will force focus on the fullscreen window */

  static const char *colors[][3] = { ${
    concatMapStringsSep ",\n" (pair: ''
      [ ${pair.name} ] = { "${pair.value.fg}", "${pair.value.bg}", "${pair.value.border}" }
    '') (lib.mapAttrsToList (name: value: { inherit name value; }) cfg.colors)
  } };

  static const char *dmenucmd[] = { "${cfg.appLauncher.appCmd}",
    ${
      if cfg.appLauncher.appArgs == [ ] then
        ""
      else
        concatMapStringsSep " " (
          arg: ''"${toString arg.flag}", ${toString arg.argument},''
        ) cfg.appLauncher.appArgs
    }
    NULL };

  static const char *termcmd[]  = { "${cfg.terminal.appCmd}",
    ${
      if cfg.terminal.appArgs == [ ] then
        ""
      else
        concatMapStringsSep " " (
          arg: ''"${toString arg.flag}", ${toString arg.argument},''
        ) cfg.terminal.appArgs
    }
    NULL };

  static const char *tags[] = { ${concatMapStringsSep ", " (tag: ''"${toString tag}"'') cfg.tags} };

  static const Layout layouts[] = {
  ${concatMapStringsSep ",\n " (
    layout: ''{"${layout.symbol}", ${layout.arrangeFunction}}''
  ) cfg.layout.layouts}
  };

  static const Rule rules[] = {
  ${concatMapStringsSep ",\n " (rule: ''
    {
    "${rule.class}", ${rule.instance}, ${rule.title}, ${toString rule.tagsMask}, ${
      if rule.isFloating then "1" else "0"
    }, ${toString rule.monitor}
    }
  '') cfg.rules}
  };

  static const Key keys[] = {
      {${cfg.terminal.modifier}, ${cfg.terminal.launchKey}, spawn, {.v=termcmd}},
      {${cfg.appLauncher.modifier}, ${cfg.appLauncher.launchKey}, spawn, {.v=dmenucmd}},

      ${
        # create default key bindings before user defined bindings
        concatMapStringsSep ",\n        " (
          key: ''{${toString key.modifier}, ${key.key}, ${key.function}, ${key.argument} }''
        ) (if cfg.key.useDefault then defaultKeys ++ cfg.key.keys else cfg.key.keys)
      },

      ${
        # create tage keys bindings
        concatMapStringsSep "\n        " (
          tag: ''TAGKEYS(${tag.key}, ${toString tag.tag})''
        ) cfg.tagKeys.definitions
      }
  };

  static const Button buttons[] = {
      ${
        concatMapStringsSep ",\n        " (
          button: ''{${button.click},${button.mask},${button.button},${button.function},${button.argument}}''
        ) cfg.buttons
      },
  };

  ${cfg.file.append}
''
