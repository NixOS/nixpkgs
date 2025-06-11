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
  version = "4.60.1";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-6v5iyQCP+3bJdG9uvPAsMaJ7mW2xj1kMhn8h2eLsl28=";
  };

  npmDepsHash = "sha256-P09uxOtlY9AAJyKLTdnFOfw0H6V4trr2hznEonOO58E=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postPatch = ''
    # remove cleanup which runs git commands
    substituteInPlace package.json \
      --replace-fail "npm run cleanup" "true"
  '';

  postInstall = ''
    NODE_MODULES=$out/lib/node_modules/gitlab-ci-local/node_modules

    # Remove intermediate build files for re2 to reduce dependencies.
    #
    # This does not affect the behavior. On npm `re2` does not ship
    # the build directory and downloads a prebuilt version of the
    # `re2.node` binary. This method produces the same result.
    find $NODE_MODULES/re2/build -type f ! -path "*/Release/re2.node" -delete
    strip -x $NODE_MODULES/re2/build/Release/re2.node

    # Remove files that depend on python3
    #
    # The node-gyp package is only used for building re2, so it is
    # not needed at runtime. I did not remove the whole directory
    # because of some dangling links to the node-gyp directory which
    # is not required. It is possible to remove the directory and all
    # the files that link to it, but I figured it was not worth
    # tracking down the files.
    #
    # The re2/vendor directory is used for building the re2.node
    # binary, so it is not needed at runtime.
    rm -rf $NODE_MODULES/{node-gyp/gyp,re2/vendor}

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
