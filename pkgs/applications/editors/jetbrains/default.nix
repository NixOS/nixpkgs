{
  lib,
  config,
  stdenv,
  callPackage,

  python3,

  jdk,
  vmopts ? null,
  forceWayland ? false,
}:

let
  mkJetBrainsProduct = callPackage ./builder/default.nix { inherit jdk forceWayland vmopts; };
  mkJetBrainsSource = callPackage ./source/build.nix { };

  mkSrcIde =
    path: extras: callPackage path ({ inherit mkJetBrainsProduct mkJetBrainsSource; } // extras);

  _idea-oss = mkSrcIde ./ides/idea-oss.nix { };

  # The binary builds use the same libdbm and fsnotifier as the current idea-oss source build.
  mkBinIde =
    path: extras:
    callPackage path (
      {
        inherit mkJetBrainsProduct;
        libdbm = _idea-oss.libdbm;
        fsnotifier = _idea-oss.fsnotifier;
      }
      // extras
    );

  # Common build overrides, fixes, etc.
  # TODO: These should eventually be moved outside of this file
  pyCharmCommonOverrides = (
    finalAttrs: previousAttrs:
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      buildInputs =
        with python3.pkgs;
        (previousAttrs.buildInputs or [ ])
        ++ [
          python3
          setuptools
        ];
      preInstall = ''
        echo "compiling cython debug speedups"
        if [[ -d plugins/python-ce ]]; then
            ${python3.interpreter} plugins/python-ce/helpers/pydev/setup_cython.py build_ext --inplace
        else
            ${python3.interpreter} plugins/python/helpers/pydev/setup_cython.py build_ext --inplace
        fi
      '';
      # See https://www.jetbrains.com/help/pycharm/2022.1/cython-speedups.html
    }
  );
  patchSharedLibs = lib.optionalString stdenv.hostPlatform.isLinux ''
    ls -d \
      $out/*/bin/*/linux/*/lib/liblldb.so \
      $out/*/bin/*/linux/*/lib/python3.8/lib-dynload/* \
      $out/*/plugins/*/bin/*/linux/*/lib/liblldb.so \
      $out/*/plugins/*/bin/*/linux/*/lib/python3.8/lib-dynload/* |
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
  # Sorted alphabetically. Deprecated products and aliases are at the very end.
  clion = mkBinIde ./ides/clion.nix { inherit patchSharedLibs; };
  datagrip = mkBinIde ./ides/datagrip.nix { };
  dataspell = mkBinIde ./ides/dataspell.nix { };
  gateway = mkBinIde ./ides/gateway.nix { };
  goland = mkBinIde ./ides/goland.nix { };
  idea = mkBinIde ./ides/idea.nix { };
  idea-oss = _idea-oss;
  mps = mkBinIde ./ides/mps.nix { };
  phpstorm = mkBinIde ./ides/phpstorm.nix { };
  pycharm = mkBinIde ./ides/pycharm.nix { inherit pyCharmCommonOverrides; };
  pycharm-oss = mkSrcIde ./ides/pycharm-oss.nix { inherit pyCharmCommonOverrides; };
  rider = mkBinIde ./ides/rider.nix { inherit patchSharedLibs; };
  ruby-mine = mkBinIde ./ides/ruby-mine.nix { };
  rust-rover = mkBinIde ./ides/rust-rover.nix { inherit patchSharedLibs; };
  webstorm = mkBinIde ./ides/webstorm.nix { };

  # Plugins
  plugins = callPackage ./plugins { };
}

// lib.optionalAttrs config.allowAliases rec {

  # Deprecated products and aliases.

  aqua =
    lib.warnOnInstantiate
      "jetbrains.aqua: Aqua has been discontinued by Jetbrains and is not receiving updates. It will be removed in NixOS 26.05."
      (mkBinIde ./ides/aqua.nix { });

  idea-community =
    lib.warnOnInstantiate
      "jetbrains.idea-community: IntelliJ IDEA Community has been discontinued by Jetbrains. This deprecated alias uses the, no longer updated, binary build on Darwin & Linux aarch64. On other platforms it uses IDEA Open Source, built from source. Either switch to 'jetbrains.idea-oss' or 'jetbrains.idea'. See: https://blog.jetbrains.com/idea/2025/07/intellij-idea-unified-distribution-plan/"
      (
        if stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64 then
          idea-community-bin
        else
          _idea-oss
      );

  idea-community-bin =
    lib.warnOnInstantiate
      "jetbrains.idea-community-bin: IntelliJ IDEA Community has been discontinued by Jetbrains. This binary build is no longer updated. Switch to 'jetbrains.idea-oss' for open source builds (from source) or 'jetbrains.idea' for commercial builds (binary, unfree). See: https://blog.jetbrains.com/idea/2025/07/intellij-idea-unified-distribution-plan/"
      (mkBinIde ./ides/idea-community.nix { });

  idea-ultimate =
    lib.warnOnInstantiate "'jetbrains.idea-ultimate' has been renamed to/replaced by 'jetbrains.idea'"
      (mkBinIde ./ides/idea.nix { });

  idea-community-src = lib.warnOnInstantiate "jetbrains.idea-community-src: IntelliJ IDEA Community has been discontinued by Jetbrains. This is now an alias for 'jetbrains.idea-oss', the Open Source build of IntelliJ. See: https://blog.jetbrains.com/idea/2025/07/intellij-idea-unified-distribution-plan/" _idea-oss;

  pycharm-community =
    lib.warnOnInstantiate
      "pycharm-community: PyCharm Community has been discontinued by Jetbrains. This deprecated alias uses the, no longer updated, binary build on Darwin. On Linux it uses PyCharm Open Source, built from source. Either switch to 'jetbrains.pycharm-oss' or 'jetbrains.pycharm'. See: https://blog.jetbrains.com/pycharm/2025/04/pycharm-2025"
      (
        if stdenv.hostPlatform.isDarwin then
          pycharm-community-bin
        else
          (mkSrcIde ./ides/pycharm-oss.nix { inherit pyCharmCommonOverrides; })
      );

  pycharm-community-bin =
    lib.warnOnInstantiate
      "pycharm-community-bin: PyCharm Community has been discontinued by Jetbrains. This binary build is no longer updated. Switch to 'jetbrains.pycharm-oss' for open source builds (from source) or 'jetbrains.pycharm' for commercial builds (binary, unfree). See: https://blog.jetbrains.com/pycharm/2025/04/pycharm-2025"
      (mkBinIde ./ides/pycharm-community.nix { inherit pyCharmCommonOverrides; });

  pycharm-community-src =
    lib.warnOnInstantiate
      "jetbrains.idea-community-src: PyCharm Community has been discontinued by Jetbrains. This is now an alias for 'jetbrains.pycharm-oss', the Open Source build of PyCharm. See: https://blog.jetbrains.com/pycharm/2025/04/pycharm-2025"
      (mkSrcIde ./ides/pycharm-oss.nix { inherit pyCharmCommonOverrides; });

  pycharm-professional =
    lib.warnOnInstantiate
      "'jetbrains.pycharm-professional' has been renamed to/replaced by 'jetbrains.pycharm'"
      (mkBinIde ./ides/pycharm.nix { inherit pyCharmCommonOverrides; });

  writerside =
    lib.warnOnInstantiate
      "jetbrains.writerside: Writerside has been discontinued by Jetbrains and is not receiving updates. It will be removed in NixOS 26.05."
      (mkBinIde ./ides/writerside.nix { });
}
