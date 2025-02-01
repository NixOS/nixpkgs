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
  version = "4.56.0";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-JMT0HtCeeM9gI6k44BohNjAq/EpvBtX2Iqe4VkBqvn4=";
  };

  npmDepsHash = "sha256-J+S8/JXAyt/nDkfLtSEGlR38oCb0DlJDDkc1t+IiyPA=";

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
