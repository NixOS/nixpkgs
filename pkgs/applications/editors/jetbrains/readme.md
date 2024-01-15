This directory contains the build expressions needed to build any of the jetbrains IDEs.
The jdk is in `pkgs/development/compilers/jetbrains-jdk`.
To test the build process of every IDE (as well as the process for adding plugins), build `jetbrains.plugins.tests.default`.

## How to use plugins:
 - Get the ide you want and call `jetbrains.plugins.addPlugins` with a list of plugins you want to add.
 - The list of plugins can be a list of ids or names (as in `plugins/plugins.json`)
 - Example: `jetbrains.plugins.addPlugins jetbrains.pycharm-professional [ "nixidea" ]`
 - The list can also contain a drv giving a `.jar` or `.zip` (this is how you use a plugin not added to nixpkgs)

### How to add a new plugin to nixpkgs
 - Find the page for the plugin on https://plugins.jetbrains.com
 - Find the id (it's the number after https://plugins.jetbrains.com/plugin/)
 - Run `plugins/update_plugins.py` add (plugin id)
 - If binaries need patch or some other special treatment, add an entry to `plugins/specialPlugins.nix`

## How to update stuff:
 - Run ./bin/update_bin.py
 - This will update binary IDEs and plugins, and automatically commit them
 - Source builds need a bit more effort, as they aren't automated at the moment:
   - Find the build of the stable release you want to target (usually different for pycharm and idea, should have three components)
   - I find this at https://jetbrains.com/updates/updates.xml (search for `fullNumber`)
   - Update the `buildVer` field in source/default.nix
   - Empty the `ideaHash`, `androidHash` and `jpsHash` (only `ideaHash` changes on a regular basis) fields and try to build to get the new hashes
   - Run `nix build .#jetbrains.(idea/pycharm)-community-source.src`, then `./source/build_maven.py source/idea_maven_artefacts.json result/`
   - Update `source/brokenPlugins.json` (from https://plugins.jetbrains.com/files/brokenPlugins.json)
   - Do a test build
   - If it succeeds, make a PR/merge
   - If it fails, ping/message GenericNerdyUsername

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
