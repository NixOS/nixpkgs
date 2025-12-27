# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: MIT
{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnet-sdk_9,
  dotnet-aspnetcore_9,
  nix-update-script,
  _experimental-update-script-combinators,
  nixosTests,
}:

buildDotnetModule (finalAttrs: {
  pname = "shokofin";
  version = "5.0.6";

  src = fetchFromGitHub {
    owner = "ShokoAnime";
    repo = "Shokofin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2B2vvdwfeRYAuuMM60nhjDlrOu0dWqBnw6LtCz8QvK4=";
  };

  dotnet-sdk = dotnet-sdk_9;
  dotnet-runtime = dotnet-aspnetcore_9;

  nugetDeps = ./deps.json;
  projectFile = "Shokofin/Shokofin.csproj";
  dotnetBuildFlags = "/p:InformationalVersion=\"channel=stable,tag=${finalAttrs.version}\"";

  executables = [ ];

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--version-regex"
          ''v([0-9]+\.[0-9]+\.[0-9]+).*''
          "--src-only"
        ];
      })
      finalAttrs.passthru.fetch-deps
    ];

    tests = { inherit (nixosTests) shoko; };
  };

  meta = {
    homepage = "https://github.com/ShokoAnime/Shokofin";
    changelog = "https://github.com/ShokoAnime/Shokofin/releases/tag/v${finalAttrs.version}";
    description = "Shoko anime Jellyfin integration plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nanoyaki ];
    inherit (dotnet-sdk_9.meta) platforms;
  };
})
