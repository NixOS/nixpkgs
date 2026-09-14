{
  # keep-sorted start
  callPackage,
  config,
  lib,
  stdenv,
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

  # Sorted alphabetically. Deprecated products and aliases are at the very end.
  clion = callPackage ./ides/clion.nix { };
  datagrip = callPackage ./ides/datagrip.nix { };
  dataspell = callPackage ./ides/dataspell.nix { };
  gateway = callPackage ./ides/gateway.nix { };
  goland = callPackage ./ides/goland.nix { };
  idea = callPackage ./ides/idea.nix { };
  idea-oss = callPackage ./ides/idea-oss.nix { };
  mps = callPackage ./ides/mps.nix { };
  phpstorm = callPackage ./ides/phpstorm.nix { };
  pycharm = callPackage ./ides/pycharm.nix { };
  pycharm-oss = callPackage ./ides/pycharm-oss.nix { };
  rider = callPackage ./ides/rider.nix { };
  ruby-mine = callPackage ./ides/ruby-mine.nix { };
  rust-rover = callPackage ./ides/rust-rover.nix { };
  webstorm = callPackage ./ides/webstorm.nix { };

  # Plugins
  plugins = callPackage ./plugins { };
}

// lib.optionalAttrs config.allowAliases {

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
