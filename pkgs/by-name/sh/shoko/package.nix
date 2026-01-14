{
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  nixosTests,
  lib,
  mediainfo,
  rhash,
  _experimental-update-script-combinators,
  nix-update-script,
  writeShellScript,
  path,

  withNet9 ? false,
}:

buildDotnetModule (finalAttrs: {
  pname = "shoko";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "ShokoAnime";
    repo = "ShokoServer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V8DwYLjxklKYmOnYNLp51GRJXgOXKnbgDD4DL4T4lVc=";
    fetchSubmodules = true;
  };

  patches = lib.optionals withNet9 [
    ./net9deps.patch
  ];

  dotnet-sdk = dotnetCorePackages.combinePackages (
    [ dotnetCorePackages.sdk_8_0 ] ++ lib.optionals withNet9 [ dotnetCorePackages.sdk_9_0 ]
  );
  dotnet-runtime = dotnetCorePackages.combinePackages (
    [ dotnetCorePackages.sdk_8_0.aspnetcore ]
    ++ lib.optionals withNet9 [ dotnetCorePackages.sdk_9_0.aspnetcore ]
  );

  nugetDeps = if withNet9 then ./net9deps.json else ./deps.json;
  projectFile = "Shoko.CLI/Shoko.CLI.csproj";
  dotnetBuildFlags = "/p:InformationalVersion=\"channel=stable\"";
  dotnetInstallFlags = lib.optionalString withNet9 "-f net9.0";

  executables = [ "Shoko.CLI" ];
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${mediainfo}/bin"
  ];
  runtimeDeps = [ rhash ];

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--version-regex"
          ''v([0-9]+\.[0-9]+\.[0-9]+).*''
        ];
      })
      [
        (writeShellScript "update-shoko-withNet9" ''
          NIXPKGS_PATH="$1"
          $(nix-build -E 'with import '"$NIXPKGS_PATH"' { }; (shoko.override { withNet9 = true; }).fetch-deps')
        '')
        path
      ]
    ];

    tests = { inherit (nixosTests.shoko) default withPlugins; };
  };

  meta = {
    homepage = "https://github.com/ShokoAnime/ShokoServer";
    changelog = "https://github.com/ShokoAnime/ShokoServer/releases/tag/v${finalAttrs.version}";
    description = "Backend for the Shoko anime management system";
    license = lib.licenses.mit;
    mainProgram = "Shoko.CLI";
    maintainers = with lib.maintainers; [
      diniamo
      nanoyaki
    ];
    inherit (finalAttrs.dotnet-sdk.meta) platforms;
  };
})
