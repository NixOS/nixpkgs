# If using this package, kanidm will be built with two patches allowing both
# oauth2 basic secrets and admin credentials to be provisioned.
# This is NOT officially supported (and will likely never be),
# see https://github.com/kanidm/kanidm/issues/1747.
# Please report any provisioning-related errors to
# https://github.com/oddlama/kanidm-provision/issues/ instead.
{
  kanidm,
  lib,
  nixosTests,
}:
kanidm.overrideAttrs (old: {
  pname = "kanidm-with-secret-provisioning";
  patches = old.patches ++ [
    (
      ./.
      + "/patches/${
        lib.replaceStrings [ "." ] [ "_" ] (lib.versions.majorMinor old.version)
      }/oauth2-basic-secret-modify.patch"
    )
    (
      ./.
      + "/patches/${
        lib.replaceStrings [ "." ] [ "_" ] (lib.versions.majorMinor old.version)
      }/recover-account.patch"
    )
  ];

  passthru = old.passthru // {
    tests = {
      kanidm-provisioning = nixosTests.kanidm-provisioning.extend {
        modules = [ { _module.args.kanidmPackage = old.passthru.finalPackage; } ];
      };
    };

    updateScript = [ ];
  };

  meta = old.meta // {
    maintainers = with lib.maintainers; [ oddlama ];
  };
})
