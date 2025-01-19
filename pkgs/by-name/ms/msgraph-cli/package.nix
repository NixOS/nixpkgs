{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  libsecret,
}:
buildDotnetModule rec {
  pname = "msgraph-cli";
  version = "v1.9.0";

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-cli";
    rev = version;
    hash = "sha256-bpdxzVlQWQLNYTZHN25S6qa3NKHhDc+xV6NvzSNMVnQ=";
  };

  projectFile = "src/msgraph-cli.csproj";

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  runtimeDeps = [ libsecret ];

  passthru.updateScript = ./update.sh;
  meta = with lib; {
    mainProgram = "mgc";
    description = "Microsoft Graph CLI";
    homepage = "https://github.com/microsoftgraph/msgraph-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ nazarewk ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
