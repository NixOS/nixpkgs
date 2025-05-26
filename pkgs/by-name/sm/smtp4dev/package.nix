{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  dotnetCorePackages,
  nix-update-script,
}:
let
  version = "3.8.6";
  src = fetchFromGitHub {
    owner = "rnwood";
    repo = "smtp4dev";
    tag = version;
    hash = "sha256-k4nerh4cVVcFQF7a4Wvcfhefa3SstEOASk+0soN0n9k=";
  };
  npmRoot = "Rnwood.Smtp4dev/ClientApp";
  patches = [ ./smtp4dev-npm-packages.patch ];
in
buildDotnetModule {
  inherit
    version
    src
    npmRoot
    patches
    ;
  pname = "smtp4dev";

  nativeBuildInputs = [
    nodejs
    nodejs.python
    npmHooks.npmConfigHook
    stdenv.cc # c compiler is needed for compiling npm-deps
  ];

  npmDeps = fetchNpmDeps {
    inherit src patches;
    hash = "sha256-Uj0EnnsA+QHq5KHF2B93OG8rwxYrV6sEgMTbd43ttCA=";
    postPatch = "cd ${npmRoot}";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  projectFile = "Rnwood.Smtp4dev/Rnwood.Smtp4dev.csproj";
  nugetDeps = ./deps.json;
  executables = [ "Rnwood.Smtp4dev" ];

  postFixup = ''
    mv $out/bin/Rnwood.Smtp4dev $out/bin/smtp4dev
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^(\\d+\\.\\d+\\.\\d+)$" ];
  };

  meta = {
    description = "Fake smtp email server for development and testing";
    homepage = "https://github.com/rnwood/smtp4dev";
    license = lib.licenses.bsd3;
    mainProgram = "smtp4dev";
    maintainers = with lib.maintainers; [
      rucadi
      jchw
    ];
    platforms = lib.platforms.unix;
  };
}
