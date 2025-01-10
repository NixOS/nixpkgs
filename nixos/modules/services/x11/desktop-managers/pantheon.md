# Pantheon Desktop {#chap-pantheon}

Pantheon is the desktop environment created for the elementary OS distribution. It is written from scratch in Vala, utilizing GNOME technologies with GTK and Granite.

## Enabling Pantheon {#sec-pantheon-enable}

All of Pantheon is working in NixOS and the applications should be available, aside from a few [exceptions](https://github.com/NixOS/nixpkgs/issues/58161). To enable Pantheon, set
```nix
{
  services.xserver.desktopManager.pantheon.enable = true;
}
```
This automatically enables LightDM and Pantheon's LightDM greeter. If you'd like to disable this, set
```nix
{
  services.xserver.displayManager.lightdm.greeters.pantheon.enable = false;
  services.xserver.displayManager.lightdm.enable = false;
}
```
but please be aware using Pantheon without LightDM as a display manager will break screenlocking from the UI. The NixOS module for Pantheon installs all of Pantheon's default applications. If you'd like to not install Pantheon's apps, set
```nix
{
  services.pantheon.apps.enable = false;
}
```
You can also use [](#opt-environment.pantheon.excludePackages) to remove any other app (like `elementary-mail`).

## Wingpanel and Switchboard plugins {#sec-pantheon-wingpanel-switchboard}

Wingpanel and Switchboard work differently than they do in other distributions, as far as using plugins. You cannot install a plugin globally (like with {option}`environment.systemPackages`) to start using it. You should instead be using the following options:

  - [](#opt-services.xserver.desktopManager.pantheon.extraWingpanelIndicators)
  - [](#opt-services.xserver.desktopManager.pantheon.extraSwitchboardPlugs)

to configure the programs with plugs or indicators.

The difference in NixOS is both these programs are patched to load plugins from a directory that is the value of an environment variable. All of which is controlled in Nix. If you need to configure the particular packages manually you can override the packages like:
```nix
wingpanel-with-indicators.override {
  indicators = [
    pkgs.some-special-indicator
  ];
}

```
```nix
switchboard-with-plugs.override {
  plugs = [
    pkgs.some-special-plug
  ];
}
```
please note that, like how the NixOS options describe these as extra plugins, this would only add to the default plugins included with the programs. If for some reason you'd like to configure which plugins to use exactly, both packages have an argument for this:
```nix
wingpanel-with-indicators.override {
  useDefaultIndicators = false;
  indicators = specialListOfIndicators;
}
```
```nix
switchboard-with-plugs.override {
  useDefaultPlugs = false;
  plugs = specialListOfPlugs;
}
```
this could be most useful for testing a particular plug-in in isolation.

## FAQ {#sec-pantheon-faq}

[I have switched from a different desktop and Pantheon’s theming looks messed up.]{#sec-pantheon-faq-messed-up-theme}
  : Open Switchboard and go to: Administration → About → Restore Default Settings → Restore Settings. This will reset any dconf settings to their Pantheon defaults. Note this could reset certain GNOME specific preferences if that desktop was used prior.

[I cannot enable both GNOME and Pantheon.]{#sec-pantheon-faq-gnome-and-pantheon}
  : This is a known [issue](https://github.com/NixOS/nixpkgs/issues/64611) and there is no known workaround.

[Does AppCenter work, or is it available?]{#sec-pantheon-faq-appcenter}
  : AppCenter has been available since 20.03. Starting from 21.11, the Flatpak backend should work so you can install some Flatpak applications using it. However, due to missing appstream metadata, the Packagekit backend does not function currently. See this [issue](https://github.com/NixOS/nixpkgs/issues/15932).

    If you are using Pantheon, AppCenter should be installed by default if you have [Flatpak support](#module-services-flatpak) enabled. If you also wish to add the `appcenter` Flatpak remote:

    ```ShellSession
    $ flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo
    ```
