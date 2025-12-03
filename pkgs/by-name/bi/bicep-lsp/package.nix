{
  autoPatchelfHook,
  buildDotnetModule,
  coreutils,
  dotnetCorePackages,
  fetchFromGitHub,
  icu,
  lib,
  libkrb5,
  openssl,
  stdenv,
}:

buildDotnetModule rec {
  pname = "bicep-lsp";
  version = "0.34.44";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "bicep";
    tag = "v${version}";
    hash = "sha256-vyPRLPTvQkwN7unlIHs6DvpjXnXyW1PDtH9hhIOgN1A=";
  };

  projectFile = "src/Bicep.LangServer/Bicep.LangServer.csproj";

  postPatch = ''
    substituteInPlace global.json --replace-warn "8.0.406" "${dotnetCorePackages.sdk_8_0.version}"
  '';

  nugetDeps = ./deps.json;

  # From: https://github.com/Azure/bicep/blob/v0.34.44/global.json#L7
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    icu
    libkrb5
    openssl
    stdenv.cc.cc.lib
  ];

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64); # mono is not available on aarch64-darwin

  meta = {
    description = "Domain Specific Language (DSL) for deploying Azure resources declaratively";
    homepage = "https://github.com/Azure/bicep/";
    changelog = "https://github.com/Azure/bicep/releases/tag/v${version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.stridtech ];
    platforms = lib.platforms.all;
    badPlatforms = [ "aarch64-linux" ];
  };
}
