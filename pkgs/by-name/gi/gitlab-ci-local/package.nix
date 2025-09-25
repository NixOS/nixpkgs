{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  gitlab-ci-local,
  testers,
  makeBinaryWrapper,
  rsync,
  gitMinimal,
}:

buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "4.62.0";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-JcCfrrb/xAvILfHgnKoRxjWG4fvi4kVg0W+s+y25A6Y=";
  };

  npmDepsHash = "sha256-J/my72RPPwg1r1t4vO3CgMnGDP7H/Cc3apToypaK1YI=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postPatch = ''
    # remove cleanup which runs git commands
    substituteInPlace package.json \
      --replace-fail "npm run cleanup" "true"
  '';

  postInstall = ''
    wrapProgram $out/bin/gitlab-ci-local \
      --prefix PATH : "${
        lib.makeBinPath [
          rsync
          gitMinimal
        ]
      }"
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
