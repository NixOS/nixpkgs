{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:
buildDotnetModule (finalAttrs: {
  pname = "transmission-api-rpc";
  # Upstream doesn't tag releases; this matches the AssemblyName/Version pinned in the fork's own csproj (and what Cleanuparr's PackageReference expects).
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Cleanuparr";
    repo = "Transmission.API.RPC";
    rev = "1d2548c3c888a2d8b0a2bf4fbefe2f91e981e263";
    hash = "sha256-JFmTyRzHN3fDdZOoeFz89fk7kroT33tceoUpVBoWS5g=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  projectFile = "Transmission.API.RPC/Transmission.API.RPC.csproj";

  nugetDeps = ./transmission-api-rpc-deps.json;

  postPatch = ''
    # Bump the netstandard2.1 TFM to net10.0 and drop the System.* meta-packages that conflict with it.
    substituteInPlace Transmission.API.RPC/Transmission.API.RPC.csproj \
      --replace-fail '<TargetFramework>netstandard2.1</TargetFramework>' \
                     '<TargetFramework>net10.0</TargetFramework>' \
      --replace-fail '<PackageReference Include="System.Net.Http" Version="4.3.4" />' "" \
      --replace-fail '<PackageReference Include="System.Net.Requests" Version="4.3.0" />' ""
  '';

  dontPublish = true;
  packNupkg = true;

  meta = {
    description = "Transmission RPC client library (Cleanuparr fork), packed for use as a local NuGet dependency";
    homepage = "https://github.com/Cleanuparr/Transmission.API.RPC";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
