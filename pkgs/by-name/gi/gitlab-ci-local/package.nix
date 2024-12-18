{ buildNpmPackage
, fetchFromGitHub
, lib
, nix-update-script
}:

buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "4.52.0";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-qNrZInSLb7IA8YTRPKlTWJ42uavrNTV5A62twwjuOag=";
  };

  npmDepsHash = "sha256-3Teow+CyUB6LrkSuOs1YYsdrxsorgJnU2g6k3XBL9S0=";

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
