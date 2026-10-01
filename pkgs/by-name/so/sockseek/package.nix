{
  buildDotnetModule,
  fetchFromGitHub,
  icu,
  libgcc,
  openssl,
  stdenv,
  zlib,
  dotnetCorePackages,
  lib,
}:
let
  version = "3.0.5";
in
buildDotnetModule {
  pname = "sockseek";
  inherit version;

  src = fetchFromGitHub {
    owner = "fiso64";
    repo = "sockseek";
    rev = "v${version}";
    hash = "sha256-ao+N9HASVDTk5fh5ikTABQdNYi6czyyKW3jeyJdw+bY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  projectFile = [
    "Sockseek.HelpGenerator/Sockseek.HelpGenerator.csproj"
    "Sockseek.Cli/Sockseek.Cli.csproj"
  ];
  nugetDeps = ./deps.json;
  runtimeDeps = [
    icu
    libgcc
    openssl
    (lib.getLib stdenv.cc.cc)
    zlib
  ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnetBuildFlags = [
    "--property:OpenApiGenerateDocuments=false"
  ];
  executables = [ "sockseek" ];

  meta = {
    description = "Advanced download tool for Soulseek, soon a client";
    homepage = "https://github.com/fiso64/sockseek";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.kfears ];
  };
}
