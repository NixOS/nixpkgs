{
  pkgs,
}:

# The aws-sdk-cpp tests are flaky.  Since pull requests to staging
# cause nix to be rebuilt, this means that staging PRs end up
# getting false CI failures due to whatever is flaky in the AWS
# SDK tests.  Since none of our CI needs to (or should be able to)
# contact AWS S3, let's just omit it all from the Nix that runs
# CI.  Bonus: the tests build way faster.
#
# See also: https://github.com/NixOS/nix/issues/7582

builtins.mapAttrs (
  attr: pkg:
  if
    # TODO descend in `nixComponents_*` and override `nix-store`. Also
    # need to introduce the flag needed to do that with.
    #
    # This must be done before Nix 2.26 and beyond becomes the default.
    !(builtins.elem attr [
      "nixComponents_2_26"
      "nix_2_26"
      "latest"
    ])
    # There may-be non-package things, like functions, in there too
    && builtins.isAttrs pkg
  then
    pkg.override { withAWS = false; }
  else
    pkg
) pkgs.nixVersions
