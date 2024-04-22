{ buildNpmPackage
, fetchFromGitHub
, lib
, nix-update-script
}:

buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "4.47.0";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-AMqifAdC4aPra/KfM0Z8L1mF6+lA0dv9tt/cXSd3Ov4=";
  };

  npmDepsHash = "sha256-GVqGA4aMfA08j/+fy+DA6udi52lmfDeAkE59d9CMAqg=";

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
