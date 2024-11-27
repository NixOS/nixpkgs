{ buildNpmPackage
, fetchFromGitHub
, lib
, nix-update-script
, gitlab-ci-local
, testers
}:

buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "4.55.0";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-rfe2vvg6F4MzV/FN52cf31Ef0XlMGM+UpbSRq2vinsM=";
  };

  npmDepsHash = "sha256-uv0/pasytEKEhkQXhjh51YWPMaskTEb3w4vMaMpspmI=";

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

  meta = with lib;{
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
