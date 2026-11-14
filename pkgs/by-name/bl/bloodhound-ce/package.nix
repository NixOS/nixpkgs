{
  buildGo127Module,
  fetchFromGitHub,
  fetchurl,
  lib,
  makeWrapper,
  nodejs_26,
  p7zip,
  python3,
  stdenv,
  substitute,
  versionCheckHook,
  yarn-berry_4,
}:
let
  inherit (lib)
    concatLines
    mapAttrs'
    mapAttrsToList
    pipe
    ;
  inherit (lib.versions) major minor patch;

  # reference: https://github.com/SpecterOps/BloodHound/blob/main/dockerfiles/bloodhound.Dockerfile

  pname = "bloodhound-ce";
  version = "9.9.0";

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "BloodHound";
    tag = "v${version}";
    hash = "sha256-SP8KnnL5VhZLM+Uow1DofAt8tqulFB0OoH9VWFs0/K0=";

    postFetch = ''
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry_4.lockfileVersion
          ];
        })
      }
    '';
  };

  yarn-berry = yarn-berry_4;

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "bloodhound-ce-frontend";
    inherit src version;

    nativeBuildInputs = [
      nodejs_26
      yarn-berry
      yarn-berry.yarnBerryConfigHook

      # for node-gyp builds
      (python3.withPackages (
        p: with p; [
          distutils
        ]
      ))
    ];

    missingHashes = ./missing-hashes.json;

    offlineCache = yarn-berry.fetchYarnBerryDeps {
      inherit (finalAttrs) missingHashes src;
      hash = "sha256-FSydgrjBrgRVO0XnlAwv5G0kzxiRUsFNvenQ3k/c42I=";
    };

    prePatch = ''
      sed -i '/npmMinimalAgeGate/d' .yarnrc.yml
    '';

    preConfigure = ''
      export JOBS=$NIX_BUILD_CORES
    '';

    buildPhase = ''
      runHook preBuild
      yarn build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r cmd/ui/dist $out
      runHook postInstall
    '';
  });

  azurehoundVersion = "3.1.3";
  sharphoundVersion = "2.17.1";

  azurehoundHashes = {
    darwin_amd64 = "sha256-O2Lzta29cZOA6lbUKIyEQm8jRNqFwd0iShqYrmiauZ4=";
    darwin_arm64 = "sha256-PedhEv5X8PKw3tXVjrIlOmGlj1T2fkkFCW+a+stQ4kc=";
    linux_amd64 = "sha256-uBQRaphQZY7za+VMP44tFWCgVgyjdwUiBt76wGTlpo0=";
    linux_arm64 = "sha256-5Btf42b8R+Tp+z0EVBd4Q/bZL86la0AK8KJW6bzFWvo=";
    windows_amd64 = "sha256-1sVDq+C3NkDSuDn9G9MN1V88D+qDcL7wYgCpBzyxZvw=";
    windows_arm64 = "sha256-TWk8ciZU8H7gfbUS8jvf/5S5DWS5VOWNXnltQt3CBSk=";
  };

  azurehoundSources = mapAttrs' (name: hash: {
    name = "azurehound_${name}";
    value = fetchurl {
      url = "https://github.com/SpecterOps/AzureHound/releases/download/v${azurehoundVersion}/azurehound_v${azurehoundVersion}_${name}.zip";
      inherit hash;
    };
  }) azurehoundHashes;

  sharphoundSource = fetchurl {
    url = "https://github.com/SpecterOps/SharpHound/releases/download/v${sharphoundVersion}/sharphound_v${sharphoundVersion}_windows_x86.zip";
    hash = "sha256-Y41tQI+HBnpmSzge/BHa5ddry/tFFFJFMUX5Y8cJsko=";
  };

  collectors = pipe azurehoundSources [
    (mapAttrsToList (_: x: "cp ${x} ${baseNameOf x.url}"))
    concatLines
    (
      copyAzurehoundZips:
      stdenv.mkDerivation {
        pname = "bloodhound-ce-collectors";
        inherit src version;

        nativeBuildInputs = [ p7zip ];

        installPhase = ''
          mkdir -p $out/{azure,sharp}hound

          ${copyAzurehoundZips}
          7z x 'azurehound_*.zip' '-oartifacts/*'
          (cd artifacts; 7z a -tzip -mx9 $out/azurehound/azurehound-${azurehoundVersion}.zip *)

          cp ${sharphoundSource} $out/sharphound/sharphound-${sharphoundVersion}.zip
          for i in $out/*/*.zip; do sha256sum "$i" > "$i.sha256"; done
        '';
      }
    )
  ];
in
buildGo127Module {
  inherit pname src version;

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-X github.com/specterops/bloodhound/cmd/api/src/version.majorVersion=${major version}"
    "-X github.com/specterops/bloodhound/cmd/api/src/version.minorVersion=${minor version}"
    "-X github.com/specterops/bloodhound/cmd/api/src/version.patchVersion=${patch version}"
  ];

  subPackages = [
    "cmd/api/src/cmd/bhapi"
  ];

  vendorHash = "sha256-HY5bQ4+SXJ4KBvn6rEWZYFHZcO8dk2DS7yi+TtLUnv8=";

  overrideModAttrs = {
    preBuild = ""; # go modules shouldn't depend on frontend
  };

  preBuild = ''
    rm -rf            cmd/api/src/api/static/assets
    cp -r ${frontend} cmd/api/src/api/static/assets
  '';

  postInstall = ''
    mv $out/bin/{bhapi,bloodhound-ce}

    wrapProgram $out/bin/bloodhound-ce \
      --set BHE_COLLECTORS_BASE_PATH ${collectors}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = azurehoundSources // {
    inherit
      azurehoundVersion
      sharphoundVersion
      sharphoundSource
      collectors
      frontend
      ;

    updateScript = ./update.sh;
  };

  meta = {
    description = "Six Degrees of Domain Admin";
    homepage = "https://github.com/SpecterOps/BloodHound";
    changelog = "https://github.com/SpecterOps/BloodHound/releases/tag/v${version}";
    downloadPage = "https://github.com/SpecterOps/BloodHound/releases";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eleonora ];
    mainProgram = "bloodhound-ce";
  };
}
