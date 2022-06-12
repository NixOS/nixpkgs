# Eclipse {#sec-eclipse}

The Nix expressions related to the Eclipse platform and IDE are in [`pkgs/applications/editors/eclipse`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/eclipse).

Nixpkgs provides a number of packages that will install Eclipse in its various forms. These range from the bare-bones Eclipse Platform to the more fully featured Eclipse SDK or Scala-IDE packages and multiple version are often available. It is possible to list available Eclipse packages by issuing the command:

```ShellSession
$ nix-env -f '<nixpkgs>' -qaP -A eclipses --description
```

Once an Eclipse variant is installed, it can be run using the `eclipse` command, as expected. From within Eclipse, it is then possible to install plugins in the usual manner by either manually specifying an Eclipse update site or by installing the Marketplace Client plugin and using it to discover and install other plugins. This installation method provides an Eclipse installation that closely resemble a manually installed Eclipse.

If you prefer to install plugins in a more declarative manner, then Nixpkgs also offer a number of Eclipse plugins that can be installed in an _Eclipse environment_. This type of environment is created using the function `eclipseWithPlugins` found inside the `nixpkgs.eclipses` attribute set. This function takes as argument `{ eclipse, plugins ? [], jvmArgs ? [] }` where `eclipse` is a one of the Eclipse packages described above, `plugins` is a list of plugin derivations, and `jvmArgs` is a list of arguments given to the JVM running the Eclipse. For example, say you wish to install the latest Eclipse Platform with the popular Eclipse Color Theme plugin and also allow Eclipse to use more RAM. You could then add:

```nix
packageOverrides = pkgs: {
  myEclipse = with pkgs.eclipses; eclipseWithPlugins {
    eclipse = eclipse-platform;
    jvmArgs = [ "-Xmx2048m" ];
    plugins = [ plugins.color-theme ];
  };
}
```

to your Nixpkgs configuration (`~/.config/nixpkgs/config.nix`) and install it by running `nix-env -f '<nixpkgs>' -iA myEclipse` and afterward run Eclipse as usual. It is possible to find out which plugins are available for installation using `eclipseWithPlugins` by running:

```ShellSession
$ nix-env -f '<nixpkgs>' -qaP -A eclipses.plugins --description
```

If there is a need to install plugins that are not available in Nixpkgs then it may be possible to define these plugins outside Nixpkgs using the `buildEclipseUpdateSite` and `buildEclipsePlugin` functions found in the `nixpkgs.eclipses.plugins` attribute set. Use the `buildEclipseUpdateSite` function to install a plugin distributed as an Eclipse update site. This function takes `{ name, src }` as argument, where `src` indicates the Eclipse update site archive. All Eclipse features and plugins within the downloaded update site will be installed. When an update site archive is not available, then the `buildEclipsePlugin` function can be used to install a plugin that consists of a pair of feature and plugin JARs. This function takes an argument `{ name, srcFeature, srcPlugin }` where `srcFeature` and `srcPlugin` are the feature and plugin JARs, respectively.

Expanding the previous example with two plugins using the above functions, we have:

```nix
packageOverrides = pkgs: {
  myEclipse = with pkgs.eclipses; eclipseWithPlugins {
    eclipse = eclipse-platform;
    jvmArgs = [ "-Xmx2048m" ];
    plugins = [
      plugins.color-theme
      (plugins.buildEclipsePlugin {
        name = "myplugin1-1.0";
        srcFeature = fetchurl {
          url = "http://…/features/myplugin1.jar";
          sha256 = "123…";
        };
        srcPlugin = fetchurl {
          url = "http://…/plugins/myplugin1.jar";
          sha256 = "123…";
        };
      });
      (plugins.buildEclipseUpdateSite {
        name = "myplugin2-1.0";
        src = fetchurl {
          stripRoot = false;
          url = "http://…/myplugin2.zip";
          sha256 = "123…";
        };
      });
    ];
  };
}
```
