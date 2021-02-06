# Using Spotify-Spicified / Spicetify-cli's Nix API

Spicetify-cli is a tool which edits the files from Spotify, to extend it's functionality or to theme the application. To achive this with nixpkgs, you can use Spotify-Spicified. For more information on Spicetify-cli and it's features, please refer to it's GitHub repository and wiki. https://github.com/khanhas/spicetify-cli

## Basic usage

When installing the package, you will keep the default Spotify experience.

```nix
{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.spotify-spicified
  ];
}
```

If you for example want to change the theme of Spotify, you can override the theme attribute.

```nix
{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.spotify-spicified.override { theme = "SpicetifyDefault"; })
  ];
}
```

## Options

The following attributes are available for changing
| Attribute                  | Type    | Containing                                                                                                                                                                             | Default Value | Example value                               | Documentation (spicetify-cli wiki)                                           |                                                                                                      |
|----------------------------|---------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|---------------------------------------------|------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| theme                      | string  | the name of the chosen theme. All community themes from [morpheusthewhite/spicetify-themes](https://github.com/morpheusthewhite/spicetify-themes) are available by default                                            | `""`          | `"Dribbblish"`                              | [Customization](https://github.com/khanhas/spicetify-cli/wiki/Customization) |                                                                                                      |
| colorScheme                | string  | an alternative color scheme of the chosen theme                                                                                                                                        | `""`          | `"horizon"`                                 | [Customization](https://github.com/khanhas/spicetify-cli/wiki/Customization) |                                                                                                      |
| thirdParyThemes            | set     | a set of third-party themes to be made available to be set                                                                                                                             | `{}`          | [third-party example](#third-party-example) | [Customization](https://github.com/khanhas/spicetify-cli/wiki/Customization) |                                                                                                      |
| thirdParyExtensions        | set     | a set of third-party extensions to be made available to be set. After adding them here, they still need to be enabled with `enabledExtensions`                                         | `{}`          | [third-party example](#third-party-example) | [Extensions](https://github.com/khanhas/spicetify-cli/wiki/Extensions)       |                                                                                                      |
| thirdParyCustomApps        | set     | a set of third-party apps to be made available to be set. After adding them here, they still need to be enabled with `enabledCustomApps`                                               | `{}`          | [third-party example](#third-party-example) | [Custom Apps](https://github.com/khanhas/spicetify-cli/wiki/Custom-Apps)     |                                                                                                      |
| enabledExtensions          | array   | which extensions are enabled                                                                                                                                                           | `[]`          | `[ "reddit" ]`                              | [Extensions](https://github.com/khanhas/spicetify-cli/wiki/Extensions)       |                                                                                                      |
| enabledCustomApps          | array   | which custom apps are enabled                                                                                                                                                          | `[]`          | `[ "newRelease.js" ]`                       | [Custom Apps](https://github.com/khanhas/spicetify-cli/wiki/Custom-Apps)     |                                                                                                      |
| spotifyLaunchFlags         | string  | Command-line flags used when launching/restarting Spotify. Separate each flag with "\                                                                                                  | ".            | `""`                                        | `"`--show-console`"`                                                         | [Spotify Commandline Flags](https://github.com/khanhas/spicetify-cli/wiki/Spotify-Commandline-Flags) |
| injectCss                  | boolean | Whether custom css from user.css in theme folder is applied. This is enabled by default when using Dribbblish as a theme                                                               | `false`       | `true`                                      |                                                                              |                                                                                                      |
| replaceColors              | boolean | Whether custom colors is applied. This is enabled by default when using Dribbblish as a theme                                                                                          | `false`       | `true`                                      |                                                                              |                                                                                                      |
| overwriteAssets            | boolean | Whether assets can be overwritten. This is enabled by default when using Dribbblish as a theme                                                                                         | `false`       | `true`                                      |                                                                              |                                                                                                      |
| disableSentry              | boolean | Prevents Sentry and Amazon Qualaroo to send console log/error/warning to Spotify developers. Enable if you don't want to catch their attention when developing extension or app.       | `true`        | `false`                                     |                                                                              |                                                                                                      |
| disableUiLogging           | boolean | Various elements logs every user clicks, scrolls. Enable to stop logging and improve user experience.                                                                                  | `true`        | `false`                                     |                                                                              |                                                                                                      |
| removeRtlRule              | boolean | To support Arabic and other Right-To-Left language, Spotify added a lot of CSS rules that are obsoleted to Left-To-Right users. Enable to remove all of them and improve render speed. | `true`        | `false`                                     |                                                                              |                                                                                                      |
| exposeApis                 | boolean | Leaks some Spotify's API, functions, objects to Spicetify global object that are useful for making extensions to extend Spotify functionality.                                         | `true`        | `false`                                     |                                                                              |                                                                                                      |
| disableUpgradeCheck        | boolean | Prevent Spotify checking new version and visually notifying user.                                                                                                                      | `true`        | `false`                                     |                                                                              |                                                                                                      |
| fastUserSwitching          | boolean | Enable/Disable ability to quickly change account. Open it in profile menu.                                                                                                             | `false`       | `true`                                      |                                                                              |                                                                                                      |
| visualizationHighFramerate | boolean | Force Visualization in Lyrics app to render in 60fps.                                                                                                                                  | `false`       | `true`                                      |                                                                              |                                                                                                      |
| radio                      | boolean | Enable/Disable Radio page. Access it in left sidebar.                                                                                                                                  | `false`       | `true`                                      |                                                                              |                                                                                                      |
| songPage                   | boolean | Enable/Disable ability to click at song name in player bar will access that song page (instead of its album page) to discover playlists it appearing on.                               | `false`       | `true`                                      |                                                                              |                                                                                                      |
| experimentalFeatures       | boolean | Enable/Disable ability access to Experimental Features of Spotify. Open it in profile menu (top right corner).                                                                         | `false`       | `true`                                      |                                                                              |                                                                                                      |
| home                       | boolean | Enable/Disable Home page. Access it in left sidebar.                                                                                                                                   | `false`       | `true`                                      |                                                                              |                                                                                                      |
| lyricAlwaysShow            | boolean | Force Lyrics button to show all the time in player bar. Useful for who want to watch visualization page.                                                                               | `false`       | `true`                                      |                                                                              |                                                                                                      |
| lyricForceNoSync           | boolean | Force displaying all of lyrics.                                                                                                                                                        | `false`       | `true`                                      |                                                                              |                                                                                                      |


## Third-party example

To use third-party components like themes, extensions and plugins, you need to provide a set with those assets. After registering them to be found, you still need to enable them.

```nix
{ pkgs, ... }:

let
  av = pkgs.fetchFromGitHub {
    owner = "amanharwara";
    repo = "spicetify-autoVolume";
    rev = "d7f7962724b567a8409ef2898602f2c57abddf5a";
    sha256 = "1pnya2j336f847h3vgiprdys4pl0i61ivbii1wyb7yx3wscq7ass";
  };
in
{
  environment.systemPackages = [
    (pkgs.spotify-spicified.override {
      enabledExtensions = [ "autoVolume.js" ];
      thirdParyExtensions = {
        "autoVolume.js" = "${av}/autoVolume.js";
      };
    })
  ];
}
```
