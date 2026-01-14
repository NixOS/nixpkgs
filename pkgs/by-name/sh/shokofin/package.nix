# SPDX-FileCopyrightText: 2025-2026 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: MIT
{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnet-sdk_9,
  dotnet-aspnetcore_9,
  nix-update-script,
  shoko,
}:

buildDotnetModule (finalAttrs: {
  pname = "shokofin";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "ShokoAnime";
    repo = "Shokofin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2YmHSHAaU7cgZjn4CnHfloYk/cPoxovDFiaIESjfAt4=";
  };

  dotnet-sdk = dotnet-sdk_9;
  dotnet-runtime = dotnet-aspnetcore_9;

  nugetDeps = ./deps.json;
  projectFile = "Shokofin/Shokofin.csproj";
  dotnetBuildFlags = "/p:InformationalVersion=\"channel=stable,tag=${finalAttrs.version}\"";

  executables = [ ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      ''v([0-9]+\.[0-9]+\.[0-9]+).*''
    ];
  };

  meta = {
    homepage = "https://github.com/ShokoAnime/Shokofin";
    changelog = "https://github.com/ShokoAnime/Shokofin/releases/tag/v${finalAttrs.version}";
    description = "Shoko anime Jellyfin integration plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nanoyaki ];
    platforms = lib.intersectLists dotnet-sdk_9.meta.platforms shoko.meta.platforms;
  };
})
