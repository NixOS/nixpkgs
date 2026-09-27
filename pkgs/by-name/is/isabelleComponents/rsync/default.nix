{
  pkgs,
  lib,
  addSettings,
}:

addSettings
  (pkgs.rsync.override {
    enableACLs = false;
    enableLZ4 = false;
    enableOpenSSL = false;
    enableXXHash = false;
    enableZstd = false;
  })
  (finalAttrs: ''
    ISABELLE_RSYNC_HOME=${finalAttrs.finalPackage}
    ISABELLE_RSYNC=${lib.getExe finalAttrs.finalPackage}
  '')
