{
  fetchFromGitHub,
  buildGoModule,
  lib,
  testers,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "gitmux";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "arl";
    repo = "gitmux";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0Cw98hTg8qPu7BUTBDEgFBOpoCxstPW9HeNXQUUjgGA=";
  };

  vendorHash = "sha256-PHY020MIuLlC1LqNGyBJRNd7J+SzoHbNMPAil7CKP/M=";

  nativeCheckInputs = [ git ];

  # After bump of Go toolchain to version >1.22, tests fail with:
  #   vendor/github.com/rogpeppe/go-internal/testscript/exe_go118.go:14:27:
  #   cannot use nopTestDeps{} (value of struct type nopTestDeps) as testing.testDeps value in argument to testing.MainStart:
  #   nopTestDeps does not implement testing.testDeps (missing method InitRuntimeCoverage)'.
  doCheck = false;

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "gitmux -V";
  };

  subPackages = [ "." ];

  meta = with lib; {
    description = "Git in your tmux status bar";
    homepage = "https://github.com/arl/gitmux";
    license = licenses.mit;
    maintainers = with maintainers; [ nialov ];
    mainProgram = "gitmux";
  };
})
