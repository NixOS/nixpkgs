{
  lib,
  fetchFromGitHub,
  buildGoModule,
  fetchYarnDeps,
  stdenv,
  nix-update-script,
  yarn,
  nodejs,
  nixosTests,
  fixup-yarn-lock,
}:

buildGoModule rec {
  pname = "alice-lg";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "alice-lg";
    repo = "alice-lg";
    tag = version;
    hash = "sha256-DlmUurpu/bs/91fLsSQ3xJ8I8NWJweynMgV6Svkf0Uo=";
  };

  vendorHash = "sha256-OkOUgW6BHJKIdY1soMqTXhL6RYy3567iL1/VZasIdvQ=";

  passthru.ui = stdenv.mkDerivation {
    pname = "alice-lg-ui";
    src = "${src}/ui";
    inherit version;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/ui/yarn.lock";
      hash = "sha256-PwByNIegKYTOT8Yg3nDMDFZiLRVkbX07z99YaDiBsIY=";
    };

    nativeBuildInputs = [
      nodejs
      yarn
      fixup-yarn-lock
    ];

    configurePhase = ''
      runHook preConfigure

      # Yarn and bundler wants a real home directory to write cache, config, etc to
      export HOME=$NIX_BUILD_TOP/fake_home

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror $yarnOfflineCache

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      fixup-yarn-lock yarn.lock

      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
      patchShebangs node_modules/
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      ./node_modules/.bin/react-scripts build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv build $out

      runHook postInstall
    '';
  };

  preBuild = ''
    cp -R ${passthru.ui}/ ui/build/
  '';

  subPackages = [ "cmd/alice-lg" ];
  doCheck = false;

  passthru = {
    tests = nixosTests.alice-lg;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/alice-lg/alice-lg";
    description = "Looking-glass for BGP sessions";
    changelog = "https://github.com/alice-lg/alice-lg/blob/main/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ stv0g ];
    mainProgram = "alice-lg";
  };
}
