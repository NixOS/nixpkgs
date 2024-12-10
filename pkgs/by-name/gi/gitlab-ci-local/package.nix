{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  gitlab-ci-local,
  testers,
}:

buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "4.53.0";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-VLBVfA4x4gaj7e37W7EqehJpYhmEgTatIL2IrO4i+Z8=";
  };

  npmDepsHash = "sha256-HAat2D45XeIjDW207Fn5M7O1sqjHOV2gxm2Urzxw+PU=";

  postPatch = ''
    # remove cleanup which runs git commands
    substituteInPlace package.json \
      --replace-fail "npm run cleanup" "true"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = gitlab-ci-local;
    };
  };

  meta = with lib; {
    description = "Run gitlab pipelines locally as shell executor or docker executor";
    mainProgram = "gitlab-ci-local";
    longDescription = ''
      Tired of pushing to test your .gitlab-ci.yml?
      Run gitlab pipelines locally as shell executor or docker executor.
      Get rid of all those dev specific shell scripts and make files.
    '';
    homepage = "https://github.com/firecow/gitlab-ci-local";
    license = licenses.mit;
    maintainers = with maintainers; [ pineapplehunter ];
    platforms = platforms.all;
  };
}
