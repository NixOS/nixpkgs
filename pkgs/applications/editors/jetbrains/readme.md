This directory contains the build expressions needed to build any of the jetbrains IDEs.
The jdk is in `pkgs/development/compilers/jetbrains-jdk`.

## Tests:
- To test the build process of every IDE (as well as the process for adding plugins), build `jetbrains.plugins.tests.empty`.
- To test the build process with all plugins\* supported by all IDEs, build `jetbrains.plugins.tests.all`.
- To test only plugins for a specific IDE\*, build `jetbrains.ide-name.tests.plugins.all`.
- To test that plugins are correctly stored in the plugins directory, build `jetbrains.plugins.tests.stored-correctly`.

\*: Plugins marked as broken in nixpkgs are skipped: When updating/fixing plugins, please check the `broken-plugins` in `plugins/tests.nix` and update it if needed.

## How to use plugins:
 - Get the ide you want and call `jetbrains.plugins.addPlugins` with a list of plugins you want to add.
 - The list of plugins can be a list of ids or names (as in `plugins/plugins.json`)
 - Example: `jetbrains.plugins.addPlugins jetbrains.pycharm-professional [ "nixidea" ]`
 - The list can also contain drvs giving the directory contents of the plugin (this is how you use a plugin not added to nixpkgs) or a single `.jar` (executable). For an example, look at the implementation of `fetchPluginSrc` in `plugins/default.nix`.

### How to add a new plugin to nixpkgs
 - Find the page for the plugin on https://plugins.jetbrains.com
 - Find the id (it's the number after https://plugins.jetbrains.com/plugin/)
 - Run `plugins/update_plugins.py` add (plugin id)
 - If binaries need patch or some other special treatment, add an entry to `plugins/specialPlugins.nix`

## How to update stuff:
 - Run ./bin/update_bin.py, this will update binary IDEs and plugins, and automatically commit them
 - Source builds need a bit more effort, as they **aren't automated at the moment**:
   - Run ./source/update.py ./source/ides.json ./bin/versions.json. This will update the source version to the version of their corresponding binary packages.
   - Run these commands respectively:
     - `nix build .#jetbrains.idea-community-src.src.src && ./source/build_maven.py source/idea_maven_artefacts.json result/` for IDEA
     - `nix build .#jetbrains.pycharm-community-src.src.src && ./source/build_maven.py source/pycharm_maven_artefacts.json result/` for PyCharm
   - Update `brokenPlugins` timestamp and hash (from https://web.archive.org/web/*/https://plugins.jetbrains.com/files/brokenPlugins.json)
   - Do a test build
     - Notice that sometimes a newer Kotlin version is required to build from source, if build fails, first check the recommended Kotlin version in `.idea/kotlinc.xml` in the IDEA source root
     - Feel free to update the Kotlin version to a compatible one
   - If it succeeds, make a commit
   - Run ./plugins/update_plugins.py, this will update plugins and automatically commit them
   - make a PR/merge
   - If it fails, ping/message GenericNerdyUsername or the nixpkgs Jetbrains maintainer team

## How to add an IDE:
 - Make dummy entries in `bin/versions.json` (make sure to set the version to something older than the real one)
 - Run `bin/update_bin.py`
 - Add an entry in `bin/ides.json`
 - Add an entry in `default.nix`

### TODO:
 - move/copy plugin docs to nixpkgs manual
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
   - test plugins
   - from source build
   - see if build (binary or source) works without expat
 - on `x86_64-darwin`:
   - test plugins
   - from source build
 - on `aarch64-darwin`:
   - test plugins
   - from source build
