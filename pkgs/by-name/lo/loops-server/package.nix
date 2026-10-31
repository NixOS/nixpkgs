{
  lib,
  fetchFromGitHub,
  php,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  nix-update-script,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "loops-server";
  version = "1.0.0-beta.14";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "joinloops";
    repo = "loops-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oH44zXcRaUuwQINCSKN/0b1aq1WyV1XHEOL+rOeJNNE=";
  };

  patches = [
    # Add ability to disable https for testing
    # See https://github.com/joinloops/loops-server/pull/1431
    ./disable-hardcoded-https.patch
    # Make hardcoded s3 usage configurable
    ./make-storage-configurable.patch
  ];

  vendorHash = "sha256-fUsGb5ljj48SuFHWUHZsalXhurWsWtgI+eVEZvB799k=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-5kl0qsn9c94wL02loFZKwy42AZijYNMRljK26n52MjI=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    npmHooks.npmInstallHook
  ];

  # npmHooks.npmBuildHook wont work because it gets overriden by
  # buildComposerProject2 buildPhase
  postBuild = ''
    npm run build
  '';

  postInstall = ''
    srcDir="$out/share/php/loops-server"
    mkdir -p $out
    for item in \
      app \
      config \
      database \
      lang \
      public \
      resources \
      routes \
      vendor \
      artisan \
      composer.json
    do
      cp -r "$srcDir/$item" "$out/$item"
    done

    cp -r $srcDir/bootstrap $out/bootstrap-static
    cp -r $srcDir/storage $out/storage-static

    ln -s /run/loops-server/storage $out/storage
    ln -s /run/loops-server/storage/app/public $out/public/storage
    ln -s /run/loops-server/storage/app/public/videos $out/public/videos
    ln -s /run/loops-server/.env $out/.env
    ln -s /run/loops-server $out/bootstrap
  '';

  passthru = {
    tests = { inherit (nixosTests) loops-server; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Federated short video sharing platform";
    changelog = "https://github.com/joinloops/loops-server/releases/tag/v${finalAttrs.version}";
    homepage = "https://joinloops.org";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.onny ];
    teams = [ lib.teams.ngi ];
    platforms = php.meta.platforms;
  };
})
