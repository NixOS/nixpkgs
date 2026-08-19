{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ginkgo,
}:

buildGoModule (finalAttrs: {
  pname = "ginkgo";
  version = "2.32.1";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mXfY+txLg8z+DxPfB8D0SqZMTXNJrDBhPcSVTirkgxg=";
  };
  vendorHash = "sha256-lj8b9f5q9hbPML7uLca74lTCadNOCtGIDmvP+CUwJx4=";

  # integration tests expect more file changes
  # types tests are missing CodeLocation
  excludedPackages = [
    "integration"
    "types"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = ginkgo;
    command = "ginkgo version";
  };

  meta = {
    homepage = "https://onsi.github.io/ginkgo/";
    changelog = "https://github.com/onsi/ginkgo/blob/master/CHANGELOG.md";
    description = "Modern Testing Framework for Go";
    mainProgram = "ginkgo";
    longDescription = ''
      Ginkgo is a testing framework for Go designed to help you write expressive
      tests. It is best paired with the Gomega matcher library. When combined,
      Ginkgo and Gomega provide a rich and expressive DSL
      (Domain-specific Language) for writing tests.

      Ginkgo is sometimes described as a "Behavior Driven Development" (BDD)
      framework. In reality, Ginkgo is a general purpose testing framework in
      active use across a wide variety of testing contexts: unit tests,
      integration tests, acceptance test, performance tests, etc.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      saschagrunert
      jk
    ];
  };
})
