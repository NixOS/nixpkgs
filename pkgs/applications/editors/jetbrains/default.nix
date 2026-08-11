{
  lib,
  config,
  stdenv,
  callPackage,

  jetbrains,

  vmopts ? null,
}:

let
  # Common build overrides, fixes, etc.
  # TODO: These should eventually be moved outside of this file
  patchSharedLibs = lib.optionalString stdenv.hostPlatform.isLinux ''
    ls -d \
      $out/*/bin/*/linux/*/lib/liblldb.so \
      $out/*/bin/*/linux/*/lib/python3.*/lib-dynload/* \
      $out/*/plugins/*/bin/*/linux/*/lib/liblldb.so \
      $out/*/plugins/*/bin/*/linux/*/lib/python3.*/lib-dynload/* |
    xargs patchelf \
      --replace-needed libssl.so.10 libssl.so \
      --replace-needed libssl.so.1.1 libssl.so \
      --replace-needed libcrypto.so.10 libcrypto.so \
      --replace-needed libcrypto.so.1.1 libcrypto.so \
      --replace-needed libcrypt.so.1 libcrypt.so \
      ${lib.optionalString stdenv.hostPlatform.isAarch "--replace-needed libxml2.so.2 libxml2.so"}
  '';
in
{
  # Builders
  mkJetBrainsProduct = callPackage ./builder/default.nix {
    inherit vmopts;
  };
  mkJetBrainsSource = callPackage ./source/build.nix { };

  # Sorted alphabetically. Deprecated products and aliases are at the very end.
  clion = callPackage ./ides/clion.nix { inherit patchSharedLibs; };
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
  rider = callPackage ./ides/rider.nix { inherit patchSharedLibs; };
  ruby-mine = callPackage ./ides/ruby-mine.nix { };
  rust-rover = callPackage ./ides/rust-rover.nix { inherit patchSharedLibs; };
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
