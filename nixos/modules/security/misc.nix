{ config, lib, ... }:

with lib;

{
  meta = {
    maintainers = [ maintainers.joachifm ];
  };

  options = {
    security.allowUserNamespaces = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to allow creation of user namespaces.  A recurring problem
        with user namespaces is the presence of code paths where the kernel's
        permission checking logic fails to account for namespacing, instead
        permitting a namespaced process to act outside the namespace with the
        same privileges as it would have inside it.  This is particularly
        damaging in the common case of running as root within the namespace.
        When user namespace creation is disallowed, attempting to create
        a user namespace fails with "no space left on device" (ENOSPC).
      '';
    };
  };

  config = mkIf (!config.security.allowUserNamespaces) {
    # Setting the number of allowed user namespaces to 0 effectively disables
    # the feature at runtime.  Note that root may raise the limit again
    # at any time.
    boot.kernel.sysctl."user.max_user_namespaces" = 0;

    assertions = [
      { assertion = config.nix.useSandbox -> config.security.allowUserNamespaces;
        message = "`nix.useSandbox = true` conflicts with `!security.allowUserNamespaces`.";
      }
    ];
  };
}
