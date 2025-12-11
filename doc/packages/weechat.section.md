# WeeChat {#sec-weechat}

WeeChat can be configured to include your choice of plugins, reducing its closure size from the default configuration which includes all available plugins. To make use of this functionality, install an expression that overrides its configuration, such as:

```nix
weechat.override {
  configure = (
    { availablePlugins, ... }:
    {
      plugins = with availablePlugins; [
        python
        perl
      ];
    }
  );
}
```

If the `configure` function returns an attrset without the `plugins` attribute, `availablePlugins` will be used automatically.

The plugins currently available are `python`, `perl`, `ruby`, `guile`, `tcl` and `lua`.

The Python and Perl plugins allow the addition of extra libraries. For instance, the `inotify.py` script in `weechat-scripts` requires D-Bus or libnotify, and the `fish.py` script requires `pycrypto`. To use these scripts, use the plugin's `withPackages` attribute:

```nix
weechat.override {
  configure =
    { availablePlugins, ... }:
    {
      plugins = with availablePlugins; [
        (python.withPackages (
          ps: with ps; [
            pycrypto
            python-dbus
          ]
        ))
      ];
    };
}
```

In order to also keep all default plugins installed, it is possible to use the following method:

```nix
weechat.override {
  configure =
    { availablePlugins, ... }:
    {
      plugins = builtins.attrValues (
        availablePlugins
        // {
          python = availablePlugins.python.withPackages (
            ps: with ps; [
              pycrypto
              python-dbus
            ]
          );
        }
      );
    };
}
```

WeeChat allows to set defaults on startup using the `--run-command`. The `configure` method can be used to pass commands to the program:

```nix
weechat.override {
  configure =
    { availablePlugins, ... }:
    {
      init = ''
        /set foo bar
        /server add libera irc.libera.chat
      '';
    };
}
```

Further values can be added to the list of commands when running `weechat --run-command "your-commands"`.

Additionally, it's possible to specify scripts to be loaded when starting `weechat`. These will be loaded before the commands from `init`:

```nix
weechat.override {
  configure =
    { availablePlugins, ... }:
    {
      scripts = with pkgs.weechatScripts; [
        weechat-xmpp
        weechat-matrix-bridge
        wee-slack
      ];
      init = ''
        /set plugins.var.python.jabber.key "val"
      '';
    };
}
```

In `nixpkgs` there's a subpackage which contains derivations for WeeChat scripts. Such derivations expect a `passthru.scripts` attribute, which contains a list of all scripts inside the store path. Furthermore, all scripts have to live in `$out/share`. An exemplary derivation looks like this:

```nix
{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "exemplary-weechat-script";
  src = fetchurl {
    url = "https://scripts.tld/your-scripts.tar.gz";
    hash = "...";
  };
  passthru.scripts = [
    "foo.py"
    "bar.lua"
  ];
  installPhase = ''
    runHook preInstall

    mkdir $out/share
    cp foo.py $out/share
    cp bar.lua $out/share

    runHook postInstall
  '';
}
```
