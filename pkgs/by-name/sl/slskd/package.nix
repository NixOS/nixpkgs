{
  lib,
  buildDotnetModule,
  buildPackages,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchNpmDeps,
  mono,
  nodejs_18,
  slskd,
  testers,
  nix-update-script,
}:

let
  nodejs = nodejs_18;
  # https://github.com/NixOS/nixpkgs/blob/d88947e91716390bdbefccdf16f7bebcc41436eb/pkgs/build-support/node/build-npm-package/default.nix#L62
  npmHooks = buildPackages.npmHooks.override { inherit nodejs; };
in
buildDotnetModule rec {
  pname = "slskd";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "slskd";
    repo = "slskd";
    rev = "refs/tags/${version}";
    hash = "sha256-2IMEkNc7LqevTwsW6r6WR+2xH760wFYT5/S8dvjOz4o=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  runtimeDeps = [ mono ];

  npmRoot = "src/web";
  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src;
    sourceRoot = "${src.name}/${npmRoot}";
    hash = "sha256-eCHYPkE8eJKg0IX7hN9Wm9HsWKUFPW5T4e+o6N0CsNc=";
  };

  projectFile = "slskd.sln";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

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
