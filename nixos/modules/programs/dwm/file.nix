{ config, lib }:
let
  inherit (lib) concatMapStringsSep;
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
  boolToInt = x: if x then "1" else "0";
in
/* c */ ''
  ${cfg.file.prepend}
  static const unsigned int borderpx = ${toString cfg.borderpx};
  static const unsigned int snap     = ${toString cfg.snap};
  static const int showbar           = ${boolToInt cfg.showBar};
  static const int topbar            = ${boolToInt cfg.topBar};
  static const char *fonts[]         = { "${cfg.font.name}:size=${toString cfg.font.size}" };
  // dmenufont col_gray1 col_gray2 col_gray3 col_gray4 col_cyan have been replaced with Nix Config
  static const char *colors[][3] = {
  ${concatMapStringsSep ",\n" (
    scheme: ''[${scheme.name}]={"${scheme.fg}", "${scheme.bg}", "${scheme.border}"}''
  ) cfg.colors}
  };

  static const char *tags[] = { ${concatMapStringsSep ", " (tag: ''"${toString tag}"'') cfg.tags} };

  static const Rule rules[] = {
  ${
    let
      valueToString = val: if val != null then val else "NULL";
    in
    concatMapStringsSep ",\n " (rule: ''
      {
      "${rule.class}", ${valueToString rule.instance}, ${valueToString rule.title}, ${toString rule.tagsMask}, ${boolToInt rule.isFloating}, ${toString rule.monitor}
      }
    '') cfg.rules
  }
  };


  static const float mfact        = ${toString cfg.layout.mfact};
  static const int nmaster        = ${toString cfg.layout.nmaster};
  static const int resizehints    = ${toString cfg.layout.resizehints};
  static const int lockfullscreen = ${toString cfg.layout.lockfullscreen};

  static const Layout layouts[] = {
  ${concatMapStringsSep ",\n " (
    layout: ''{"${layout.symbol}", ${layout.arrangeFunction}}''
  ) cfg.layout.layouts}

  #define MODKEY ${cfg.modifier}
  #define TAGKEYS(KEY, TAG) \
      {${cfg.tagKeys.modifiers.viewOnlyThisTag},       KEY, view,       {.ui = 1 << TAG} }, \
      {${cfg.tagKeys.modifiers.toggleThisTagInView},   KEY, toggleview, {.ui = 1 << TAG} }, \
      {${cfg.tagKeys.modifiers.moveWindowToThisTag},   KEY, tag,        {.ui = 1 << TAG} }, \
      {${cfg.tagKeys.modifiers.toggleWindowOnThisTag}, KEY, toggletag,  {.ui = 1 << TAG} },
  };

  #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

  static char dmenumon[2] = "0";
  ${
    let
      createAppCmd = attrSet: ''
        { "${attrSet.appCmd}",
            ${lib.optionalString (attrSet.appArgs != [ ] && attrSet.appArgs != null) (
              concatMapStringsSep " " (
                arg: ''"${toString arg.flag}"${lib.optionalString (arg.argument != null) ", ${arg.argument}"},''
              ) attrSet.appArgs
            )}
            NULL };'';
    in
    ''
      static const char *dmenucmd[] = ${createAppCmd cfg.appLauncher}
      static const char *termcmd[]  = ${createAppCmd cfg.terminal}
    ''
  }

  static const Key keys[] = {
      {${
        lib.optionalString (cfg.terminal.modifier != null) cfg.terminal.modifier
      }, ${cfg.terminal.launchKey}, spawn, {.v=termcmd}},
      {${
        lib.optionalString (cfg.appLauncher.modifier != null) cfg.appLauncher.modifier
      }, ${cfg.appLauncher.launchKey}, spawn, {.v=dmenucmd}},

      ${
        # create default key bindings before user defined bindings
        concatMapStringsSep ",\n        " (
          key:
          "{${
            lib.optionalString (key.modifier != null) (toString key.modifier)
          }, ${key.key}, ${key.function}, ${key.argument} }"
        ) (if cfg.key.useDefault then defaultKeys ++ cfg.key.keys else cfg.key.keys)
      },

      ${
        # create tage keys bindings
        concatMapStringsSep "\n        " (
          tag: "TAGKEYS(${tag.key}, ${toString tag.tag})"
        ) cfg.tagKeys.definitions
      }
  };

  static const Button buttons[] = {
      ${
        concatMapStringsSep ",\n        " (
          button: "{${button.click},${button.mask},${button.button},${button.function},${button.argument}}"
        ) cfg.buttons
      },
  };

  ${cfg.file.append}
''
