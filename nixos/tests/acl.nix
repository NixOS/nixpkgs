{
  vmTools,
  perl,
  coreutils,
  acl,
}:
# Can't run this within a VM because tests require root access
# Can't easily use a standard VM test because we need to have access to intermediate build results
vmTools.runInLinuxVM (
  acl.overrideAttrs (old: {
    postPatch = old.postPatch or "" + ''
      # The runwrapper uses LD_PRELOAD to override available user/groups
      substituteInPlace Makefile.in --replace-fail \
        'TEST_LOG_COMPILER = $(srcdir)/test/runwrapper' \
        'TEST_LOG_COMPILER = $(srcdir)/test/run'
    '';
    nativeCheckInputs = old.nativeCheckInputs or [ ] ++ [
      perl
      # By default `ls` would come from bootstrap tools,
      # which doesn't support showing ACLs, which the tests rely on
      coreutils
    ];
    preCheck = ''
      cp test/test.passwd /etc/passwd
      cp test/test.group /etc/group
    '';
    doCheck = true;
    outputs = [ "out" ];
    installPhase = ''
      touch $out
    '';
  })
)
