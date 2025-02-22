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
let
  version = "3.3.4";
  src = fetchFromGitHub {
    owner = "rnwood";
    repo = "smtp4dev";
    rev = "refs/tags/${version}";
    hash = "sha256-ARq5OpFJ4o9KdBXvzOx7QLB8GNfmXWjO0RR4jKP8qRI=";
  };
  npmRoot = "Rnwood.Smtp4dev/ClientApp";
in
buildDotnetModule {
  inherit version src npmRoot;
  pname = "smtp4dev";

  nativeBuildInputs = [
    nodejs
    nodejs.python
    npmHooks.npmConfigHook
    stdenv.cc # c compiler is needed for compiling npm-deps
  ];

  npmDeps = fetchNpmDeps {
    src = "${src}/${npmRoot}";
    hash = "sha256-VBcfRKYe/uPf6urWuLI5TrnX9bgiKiZKo+N4zL7O3SM=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  projectFile = "Rnwood.Smtp4dev/Rnwood.Smtp4dev.csproj";
  nugetDeps = ./deps.nix;
  executables = [ "Rnwood.Smtp4dev" ];

  postFixup = ''
    mv $out/bin/Rnwood.Smtp4dev $out/bin/smtp4dev
  '';

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
