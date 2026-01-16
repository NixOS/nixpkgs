# The reason this lives in nixos/tests is because `attr` is a bootstrap package,
# and it's very non-trivial to use `vmTools` in its passthru.
#
# The reason we need vmTools in the first place is because we don't allow
# extended attributes in the sandbox.
{
  lib,
  vmTools,
  attr,
  perl,
}:
vmTools.runInLinuxVM (
  attr.overrideAttrs (oa: {
    nativeCheckInputs = [ perl ];
    preCheck = "patchShebangs test";

    # FIXME(balsoft): half of the test suite is skipped because the hacky test
    # harness doesn't know that we're root even though we are (it's looking for
    # /etc/group, which we don't have). Probably best to submit a fix upstream
    # rather than patch it ourselves.
    doCheck = true;
    memSize = 4096;

    meta = oa.meta // {
      maintainers = oa.meta.maintainers or [ ] ++ [ lib.maintainers.balsoft ];
    };
  })
)
