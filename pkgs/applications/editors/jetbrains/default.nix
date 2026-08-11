{
  clion,
  datagrip,
  dataspell,
  goland,
  idea-oss,
  idea,
  jetbrains-gateway,
  jetbrains-mps,
  phpstorm,
  pycharm-oss,
  pycharm,
  rider,
  ruby-mine,
  rust-rover,
  webstorm,

  # for the aliases below
  warnAlias,

  callPackage,
  config,
  lib,

  vmopts ? null,
}:
{
  # Builders
  mkJetBrainsProduct = callPackage ./builder/default.nix {
    inherit vmopts;
  };
  mkJetBrainsSource = callPackage ./source/build.nix { };

  # Hooks
  sharedLibsHook = callPackage ./hooks/shared-libs.nix { };

  # Plugins
  plugins = callPackage ./plugins { };
}

// lib.optionalAttrs config.allowAliases {
  # These now all live in by-name.
  # This is managed by the maintainers/scripts/remove-old-aliases.py script, please run it to update these,
  # but make sure the warning/throw text says "'jetbrains.xyz' has been..." (add the jetbrains prefix).
  clion = clion; # Added 2026-08-15
  datagrip = datagrip; # Added 2026-08-15
  dataspell = dataspell; # Added 2026-08-15
  gateway = jetbrains-gateway; # Added 2026-08-15
  goland = goland; # Added 2026-08-15
  idea = idea; # Added 2026-08-15
  idea-oss = idea-oss; # Added 2026-08-15
  mps = jetbrains-mps; # Added 2026-08-15
  phpstorm = phpstorm; # Added 2026-08-15
  pycharm = pycharm; # Added 2026-08-15
  pycharm-oss = pycharm-oss; # Added 2026-08-15
  rider = rider; # Added 2026-08-15
  ruby-mine = ruby-mine; # Added 2026-08-15
  rust-rover = rust-rover; # Added 2026-08-15
  webstorm = webstorm; # Added 2026-08-15

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
