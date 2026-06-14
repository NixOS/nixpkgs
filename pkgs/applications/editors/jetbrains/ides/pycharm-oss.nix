{
  lib,
  mkJetBrainsProduct,
  mkJetBrainsSource,
  pyCharmCommonOverrides,
}:
let
  src = mkJetBrainsSource {
    # update-script-start: source-args
    version = "2026.1.2";
    buildNumber = "261.24374.152";
    buildType = "pycharm";
    ideaHash = "sha256-poFKGTO96laX2e6xebqErYVFhgyb8IRTMtLgy+X6vr4=";
    androidHash = "sha256-lbtA8/AnWWZNKnYdveiz/9mhqufbsx+dwkc2gZPzGV0=";
    restarterHash = "sha256-acCmC58URd6p9uKZrm0qWgdZkqu9yqCs23v8qgxV2Ag=";
    bazelConfig = {
      base = {
        version = "8.4.2";
        hash = "sha256-5oNYKHPaDkpunl6oC104Rh1wAEMWfLfvCFdGHlXZn4o=";
      };
      jbPatches = {
        version = "jb_20251027_92";
        hash = "sha256-13TD+Wv6qaVIAMy6okb7H1FrPu3zBloHXRuQ2Qe7X50=";
        names = [
          "0001-DRAFT-follow-307-temporary-redirect-in-HttpDownloadH.patch"
          "0002-DRAFT-ignore-credentials-in-favor-of-authorization-f.patch"
          "0003-DRAFT-pass-remote-cache-headers-to-HttpCacheClient-i.patch"
          "0004-DRAFT-fallback-to-USERPROFILE-environment-variable-w.patch"
          "0007-DRAFT-add-zstd-to-accept-encoding-in-HttpDownloadHan.patch"
          "0009-DRAFT-use-recursive-file-watcher-on-Windows-in-Watch.patch"
          "0010-DRAFT-check-junctions-by-is-other-in-WindowsFileSyst.patch"
          "0011-DRAFT-make-last-change-time-lazy-in-WindowsFileSyste.patch"
          "0012-DRAFT-add-WindowsFileSystem-readdir-to-traverse-entr.patch"
          "0013-DRAFT-switch-to-jbrsdk-v25b176.4.patch"
          "0014-DRAFT-switch-back-to-zulu-v21.40.17-on-windows-arm64.patch"
        ];
      };
      registry = {
        rev = "694f4e0ff33369796b1aaf52a5d11e3128003299";
        hash = "sha256-Cj158kkb8jr9t5mMmMcelkwRzkvmfV1sdG+LVFytLPM=";
      };
      repoCacheFODHashes = {
        x86_64-linux = "sha256-Jk2kFih5G4xU4IRNXKKYf5Gqus2RmMI07zhMk3tXBx8=";
      };
    };
    # update-script-end: source-args
  };
in
(mkJetBrainsProduct {
  inherit src;
  inherit (src)
    version
    buildNumber
    libdbm
    fsnotifier
    ;

  pname = "pycharm-oss";

  wmClass = "jetbrains-pycharm-ce";
  product = "PyCharm Open Source";
  productShort = "PyCharm";

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/pycharm/";
    description = "Free Python IDE from JetBrains (built from source)";
    longDescription = ''
      Python IDE with complete set of tools for productive development with Python programming language.
      In addition, the IDE provides high-class capabilities for professional Web development with Django framework and Google App Engine.
      It has powerful coding assistance, navigation, a lot of refactoring features, tight integration with various Version Control Systems, Unit testing and powerful Debugger.
    '';
    maintainers = with lib.maintainers; [
      tymscar
    ];
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = [ "x86_64-linux" ]; # see source.nix - also some deps only support x86_64-linux anyway right now
  };
}).overrideAttrs
  pyCharmCommonOverrides
