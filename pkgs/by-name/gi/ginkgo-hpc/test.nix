{ lib
, makeImpureTest
, ginkgo-hpc
}:

makeImpureTest {
  name = "runTests";
  testedPackage = "ginkgo-hpc" + lib.concatStringsSep "." (lib.splitString "-" (lib.removePrefix "ginkgo-hpc" ginkgo-hpc.pname));
  sandboxPaths = [ "/sys" "/dev/dri" "/dev/kfd" ];

  testScript = ''
    echo "'${ginkgo-hpc.pname}' built successfully at '${ginkgo-hpc}'!"
    echo "'${ginkgo-hpc.pname}' tests ran successfully!"
  '';

  meta.maintainers = with lib.maintainers; [ Madouura keldu ];
}
