{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  dotnetCorePackages,
}:

buildDotnetModule (finalAttrs: {
  pname = "smtp4dev";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "rnwood";
    repo = "smtp4dev";
    tag = finalAttrs.version;
    hash = "sha256-LGhx+i4PIExC6GbBwDOLi/g1TxNoMFMZomdnbtc/wNc=";
  };

  patches = [ ./smtp4dev-npm-packages.patch ];

  nativeBuildInputs = [
    nodejs
    nodejs.python
    npmHooks.npmConfigHook
    stdenv.cc # c compiler is needed for compiling npm-deps
  ];

  npmRoot = "Rnwood.Smtp4dev/ClientApp";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-Xjx3V5FH72D+CXBRZgmlkbp5evnp6F4zaHMWQB5o61w=";
    postPatch = "cd ${finalAttrs.npmRoot}";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  projectFile = "Rnwood.Smtp4dev/Rnwood.Smtp4dev.csproj";
  nugetDeps = ./deps.json;
  executables = [ "Rnwood.Smtp4dev" ];

  postFixup = ''
    mv $out/bin/Rnwood.Smtp4dev $out/bin/smtp4dev
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/smtp4dev --help | head -1 | grep -F "smtp4dev version ${finalAttrs.version}"

    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Fake smtp email server for development and testing";
    homepage = "https://github.com/rnwood/smtp4dev";
    license = lib.licenses.bsd3;
    mainProgram = "smtp4dev";
    maintainers = with lib.maintainers; [
      rucadi
      jchw
      defelo
    ];
    platforms = lib.platforms.unix;
  };
})
