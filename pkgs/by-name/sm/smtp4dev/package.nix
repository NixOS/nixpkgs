{
  buildDotnetModule,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  gcc,
  fetchNpmDeps,
  dotnetCorePackages,
  lib,
  openssl,
}:

let
  version = "3.3.4";
  src = fetchFromGitHub {
    owner = "rnwood";
    repo = "smtp4dev";
    rev = version;
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
    gcc
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

  meta = with lib; {
    description = "Fake smtp email server for development and testing";
    homepage = "https://github.com/rnwood/smtp4dev";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jchw ];
    mainProgram = "smtp4dev";
  };
}
