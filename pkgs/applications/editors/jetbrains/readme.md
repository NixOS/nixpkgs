This directory contains the build expressions needed to build any of the jetbrains IDEs.
The jdk is in `pkgs/development/compilers/jetbrains-jdk`.

## Tests:
- To test the build process of every IDE (as well as the process for adding plugins), build `jetbrains.plugins.tests.empty`.
- To test that plugins are correctly stored in the plugins directory, build `jetbrains.plugins.tests.stored-correctly`.

## How to use plugins:
 - Pass your IDE package and a list of plugin packages to `jetbrains.plugins.addPlugins`.
   E.g. `pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea [ ideavim ]`
 - The list has to contain contain drvs giving the directory contents of the plugin or a single `.jar` (executable).

Nixpkgs does not package Jetbrains plugins, however you can use third-party sources, such as
[nix-jetbrains-plugins](https://github.com/nix-community/nix-jetbrains-plugins).
Note that some plugins may not work without modification, if they are packaged in a way that is incompatible with NixOS.
You can try installing such plugins from within the IDE instead.

### Example derivations:

#### "Normal" plugin

```nix
fetchzip {
  url = "https://plugins.jetbrains.com/files/8607/786671/NixIDEA-0.4.0.18.zip";
  hash = "sha256-JShheBoOBiWM9HubMUJvBn4H3DnWykvqPyrmetaCZiM=";
}
```
#### "Single JAR file" plugin

```nix
fetchurl {
  executable = true;
  url = "https://plugins.jetbrains.com/files/7425/760442/WakaTime.jar";
  hash = "sha256-DobKZKokueqq0z75d2Fo3BD8mWX9+LpGdT9C7Eu2fHc=";
}
```

## How to update stuff:
 - Run ./bin/update_bin.py, this will update binary IDEs, and automatically commit them
 - Source builds need a bit more effort, as they **aren't automated at the moment**:
   - Run ./source/update.py ./source/sources.json ./bin/versions.json. This will update the source version to the version of their corresponding binary packages.
   - Run these commands respectively:
     - `nix build .#jetbrains.idea-oss.src.src && ./source/build_maven.py source/idea_maven_artefacts.json result/` for IDEA
     - `nix build .#jetbrains.pycharm-oss.src.src && ./source/build_maven.py source/pycharm_maven_artefacts.json result/` for PyCharm
   - Update `brokenPlugins` timestamp and hash (from https://web.archive.org/web/*/https://plugins.jetbrains.com/files/brokenPlugins.json)
   - Do a test build
     - Notice that sometimes a newer Kotlin version is required to build from source, if build fails, first check the recommended Kotlin version in `.idea/kotlinc.xml` in the IDEA source root
     - Feel free to update the Kotlin version to a compatible one
   - If it succeeds, make a commit
   - make a PR/merge
   - If it fails, ping/message GenericNerdyUsername or the nixpkgs Jetbrains maintainer team

## How to add an IDE:
 - Make dummy entries in `bin/versions.json` (make sure to set the version to something older than the real one)
 - Run `bin/update_bin.py`
 - Add an entry in `ides.json`
 - Add an entry in `default.nix`

### TODO:
 - replace `libxcrypt-legacy` with `libxcrypt` when supported
 - make `jetbrains-remote-dev.patch` cleaner
 - is extraLdPath needed for IDEA?
 - set meta.sourceProvenance for everything
 - from source builds:
   - remove timestamps in output `.jar` of `jps-bootstrap`
   - automated update scripts
   - fetch `.jar` s from stuff built in nixpkgs when available
     - what stuff built in nixpkgs provides `.jar`s we care about?
       - kotlin
   - make `configurePhase` respect `$NIX_BUILD_CORES`
   - make the subdir of the resulting tar.gz always have a release number (2023.2.2) instead of a build number (232.9921.89)
 - jdk:
   - build on darwin
   - use chromium stuff built by nixpkgs for jcef?
   - make `buildPhase` respect `$NIX_BUILD_CORES`
   - automated update script?
 - on `aarch64-linux`:
   - from source build
   - see if build (binary or source) works without expat
 - on `x86_64-darwin`:
   - from source build
 - on `aarch64-darwin`:
   - from source build
