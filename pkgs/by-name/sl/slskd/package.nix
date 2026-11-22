{
  lib,
  buildDotnetModule,
  buildPackages,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs_24,
  slskd,
  testers,
  nix-update-script,
}:

let
  nodejs = nodejs_24;
  # https://github.com/NixOS/nixpkgs/blob/d88947e91716390bdbefccdf16f7bebcc41436eb/pkgs/build-support/node/build-npm-package/default.nix#L62
  npmHooks = buildPackages.npmHooks.override { inherit nodejs; };
in
buildDotnetModule rec {
  pname = "slskd";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "slskd";
    repo = "slskd";
    tag = version;
    hash = "sha256-NYJg56/wD1gVm1Pid9H84youkYXmN8WUHrMZa9DrG9s=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  npmRoot = "src/web";
  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src;
    sourceRoot = "${src.name}/${npmRoot}";
    hash = "sha256-nfCT3yBvmRYneuOFD6wx0vUWyTxK0GQ6uOUIfzRT7tE=";
  };

  projectFile = "src/slskd/slskd.csproj";
  nugetDeps = ./deps.json;
  executables = [ "slskd" ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  testProjectFile = "tests/slskd.Tests.Unit/slskd.Tests.Unit.csproj";
  doCheck = true;
  disabledTests = [
    # Random failures on OfBorg, cause unknown
    "slskd.Tests.Unit.Transfers.Uploads.UploadGovernorTests+ReturnBytes.Returns_Bytes_To_Bucket"
  ];

  postBuild = ''
    pushd "$npmRoot"
    npm run build --legacy-peer-deps
    popd
  '';

  postInstall = ''
    rm -r $out/lib/slskd/wwwroot
    mv "$npmRoot"/build $out/lib/slskd/wwwroot
  '';

  passthru = {
    tests.version = testers.testVersion { package = slskd; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern client-server application for the Soulseek file sharing network";
    homepage = "https://github.com/slskd/slskd";
    changelog = "https://github.com/slskd/slskd/releases/tag/${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      ppom
      melvyn2
      getchoo
    ];
    mainProgram = "slskd";
    platforms = lib.platforms.linux;
  };
}
