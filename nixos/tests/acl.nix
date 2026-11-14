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
    doCheck = true;
    nativeCheckInputs = old.nativeCheckInputs or [ ] ++ [
      perl
      # By default `ls` would come from bootstrap tools,
      # which doesn't support showing ACLs, which the tests rely on
      coreutils
    ];
    preCheck = ''
      cp test/test.passwd /etc/passwd
      cp test/test.group /etc/group
      # Make sure all users we `su` to can modify the directory
      # since libtool may generate a lt- prefixed binary
      chmod -R 777 .libs
    '';
    checkFlags = old.checkFlags or [ ] ++ [
      # The runwrapper uses LD_PRELOAD to override available user/groups
      "RUN_LOG_COMPILER=test/run"
    ];
    outputs = [ "out" ];
    installPhase = ''
      touch $out
    '';
  })
)
