{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, libsecret
}:
buildDotnetModule rec {
  pname = "msgraph-cli";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-cli";
    rev = "v${version}";
    hash = "sha256-wF318w1X4LHxzoPHDQwDfWQy6sjJkM5e2xYKNE/EI/A=";
  };

  projectFile = "src/msgraph-cli.csproj";

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  runtimeDeps = [
    libsecret
  ];

  passthru.updateScript = ./update.sh;
  meta = with lib; {
    mainProgram = "mgc";
    description = "Microsoft Graph CLI";
    homepage = "https://github.com/microsoftgraph/msgraph-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ nazarewk ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
  };
}
