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
<<<<<<< HEAD
  version = "3.12.0";
=======
  version = "3.10.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rnwood";
    repo = "smtp4dev";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-1dzK0IHdjEppV62tE4Ywqs8WihLJUY4bhzJPQ1A/Eog=";
=======
    hash = "sha256-bbo4kke0deZQoD08dbUKsLUhjg/z7TaIr5qmU4SETNg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    hash = "sha256-lJyjoTTgum67j1qPtkLFGYO2sTpvN7ug0Q1jJw/Se/c=";
=======
    hash = "sha256-c0/6kbMv5CmLxS0S/p3+oZvZsuHP9gt4X43uvGQFjTw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

    $out/bin/smtp4dev --help > /dev/null

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
