{
  # keep-sorted start
  callPackage,
  clion,
  config,
  datagrip,
  dataspell,
  goland,
  intellij-idea,
  intellij-idea-oss,
  jetbrains,
  jetbrains-gateway,
  jetbrains-mps,
  lib,
  phpstorm,
  pycharm,
  pycharm-oss,
  rider,
  ruby-mine,
  rust-rover,
  stdenv,
  webstorm,
  # keep-sorted end

  vmopts ? null,
}:
{
  # Builders
  mkJetBrainsProduct = callPackage ./builder/default.nix {
    inherit vmopts;
  };
  mkJetBrainsSource = callPackage ./source/build.nix { };

  # Hooks
  cythonDebugSpeedupsHook = callPackage ./hooks/cython-debug-speedups.nix { };
  sharedLibsHook = callPackage ./hooks/shared-libs.nix { };

  # Plugins
  plugins = callPackage ./plugins { };
}

// lib.optionalAttrs config.allowAliases {
  # These now all live in by-name.
  clion = lib.warnOnInstantiate "'jetbrains.clion' has been renamed to/replaced by 'clion'" clion; # converted to warning 2026-11-19
  datagrip = lib.warnOnInstantiate "'jetbrains.datagrip' has been renamed to/replaced by 'datagrip'" datagrip; # converted to warning 2026-11-19
  dataspell = lib.warnOnInstantiate "'jetbrains.dataspell' has been renamed to/replaced by 'dataspell'" dataspell; # converted to warning 2026-11-19
  gateway = lib.warnOnInstantiate "'jetbrains.gateway' has been renamed to/replaced by 'jetbrains-gateway'" jetbrains-gateway; # converted to warning 2026-11-19
  goland = lib.warnOnInstantiate "'jetbrains.goland' has been renamed to/replaced by 'goland'" goland; # converted to warning 2026-11-19
  idea = lib.warnOnInstantiate "'jetbrains.idea' has been renamed to/replaced by 'intellij-idea'" intellij-idea; # converted to warning 2026-11-19
  idea-oss = lib.warnOnInstantiate "'jetbrains.idea-oss' has been renamed to/replaced by 'intellij-idea-oss'" intellij-idea-oss; # converted to warning 2026-11-19
  mps = lib.warnOnInstantiate "'jetbrains.mps' has been renamed to/replaced by 'jetbrains-mps'" jetbrains-mps; # converted to warning 2026-11-19
  phpstorm = lib.warnOnInstantiate "'jetbrains.phpstorm' has been renamed to/replaced by 'phpstorm'" phpstorm; # converted to warning 2026-11-19
  pycharm = lib.warnOnInstantiate "'jetbrains.pycharm' has been renamed to/replaced by 'pycharm'" pycharm; # converted to warning 2026-11-19
  pycharm-oss = lib.warnOnInstantiate "'jetbrains.pycharm-oss' has been renamed to/replaced by 'pycharm-oss'" pycharm-oss; # converted to warning 2026-11-19
  rider = lib.warnOnInstantiate "'jetbrains.rider' has been renamed to/replaced by 'rider'" rider; # converted to warning 2026-11-19
  ruby-mine = lib.warnOnInstantiate "'jetbrains.ruby-mine' has been renamed to/replaced by 'ruby-mine'" ruby-mine; # converted to warning 2026-11-19
  rust-rover = lib.warnOnInstantiate "'jetbrains.rust-rover' has been renamed to/replaced by 'rust-rover'" rust-rover; # converted to warning 2026-11-19
  webstorm = lib.warnOnInstantiate "'jetbrains.webstorm' has been renamed to/replaced by 'webstorm'" webstorm; # converted to warning 2026-11-19

  # Deprecated products and aliases.
  aqua = throw "jetbrains.aqua: Aqua has been removed as it has been discontinued by JetBrains";
  idea-community = throw "jetbrains.idea-community: IntelliJ IDEA Community has been removed as it has been discontinued by JetBrains. Either switch to 'jetbrains.idea-oss' or 'jetbrains.idea'. See: https://blog.jetbrains.com/idea/2025/07/intellij-idea-unified-distribution-plan/";
  idea-community-bin = throw "jetbrains.idea-community-bin: IntelliJ IDEA Community has been removed as it has been discontinued by JetBrains. Either switch to 'jetbrains.idea-oss' or 'jetbrains.idea'. See: https://blog.jetbrains.com/idea/2025/07/intellij-idea-unified-distribution-plan/";
  idea-community-src = throw "jetbrains.idea-community-src: IntelliJ IDEA Community has been removed as it has been discontinued by JetBrains. Either switch to 'jetbrains.idea-oss' or 'jetbrains.idea'. See: https://blog.jetbrains.com/idea/2025/07/intellij-idea-unified-distribution-plan/";
  idea-ultimate = throw "'jetbrains.idea-ultimate' has been renamed to/replaced by 'jetbrains.idea'";
  pycharm-community = throw "jetbrains.pycharm-community: PyCharm Community has been removed as it has been discontinued by JetBrains. Either switch to 'jetbrains.pycharm-oss' or 'jetbrains.pycharm'. See: https://blog.jetbrains.com/pycharm/2025/04/pycharm-2025";
  pycharm-community-bin = throw "jetbrains.pycharm-community-bin: PyCharm Community has been removed as it has been discontinued by JetBrains. Either switch to 'jetbrains.pycharm-oss' or 'jetbrains.pycharm'. See: https://blog.jetbrains.com/pycharm/2025/04/pycharm-2025";
  pycharm-community-src = throw "jetbrains.pycharm-community-src: PyCharm Community has been removed as it has been discontinued by JetBrains. Either switch to 'jetbrains.pycharm-oss' or 'jetbrains.pycharm'. See: https://blog.jetbrains.com/pycharm/2025/04/pycharm-2025";
  pycharm-professional = throw "'jetbrains.pycharm-professional' has been renamed to/replaced by 'jetbrains.pycharm'";
  writerside = throw "jetbrains.writerside: Writerside has been removed as it has been discontinued by JetBrains";
}
