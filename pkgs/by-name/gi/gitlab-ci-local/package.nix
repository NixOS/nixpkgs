{ buildNpmPackage
, fetchFromGitHub
, lib
, nix-update-script
}:

buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "4.51.0";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-D1zviTj7isAuEyzRYEyjq4sx+jo/U3ZQZLFr35/1ZNo=";
  };

  npmDepsHash = "sha256-ocrSOPLbWkU0LBpWAdl54hWr+7gE3z2sy8lJilGsExo=";

  postPatch = ''
    # remove cleanup which runs git commands
    substituteInPlace package.json \
      --replace-fail "npm run cleanup" "true"
  '';

  passthru.updateScript = nix-update-script { };

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
