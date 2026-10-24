{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  perl,
}:
buildDotnetModule (finalAttrs: {
  pname = "qbittorrent-net-client";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Cleanuparr";
    repo = "qbittorrent-net-client";
    rev = "b36a3ca40c83776f9f1b86a56e46ae718e2cf96f";
    hash = "sha256-33M+j8Phukwa5R7zo5Nuc/rSb2Dv2JYfTcXZMkFu7jw=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  projectFile = "src/QBittorrent.Client/QBittorrent.Client.csproj";

  nugetDeps = ./qbittorrent-net-client-deps.json;

  nativeBuildInputs = [ perl ];

  postPatch = ''
    perl -0777 -pi -e 's/<TargetFrameworks?>[\s\S]*?<\/TargetFrameworks?>/<TargetFramework>net10.0<\/TargetFramework>/g' \
      src/QBittorrent.Client/QBittorrent.Client.csproj

    perl -0777 -pi -e 's/<PackageReference\s+[^>]*Include="System\.[^"]*"[\s\S]*?(?:\/>|<\/PackageReference>)//g' \
      src/QBittorrent.Client/QBittorrent.Client.csproj
  '';

  dontPublish = true;
  packNupkg = true;

  meta = {
    description = "qBittorrent remote API client library (Cleanuparr fork), packed for use as a local NuGet dependency";
    homepage = "https://github.com/Cleanuparr/qbittorrent-net-client";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
