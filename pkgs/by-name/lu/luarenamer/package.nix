# SPDX-FileCopyrightText: 2025-2026 Hana Kretzer <hanakretzer@nanoyaki.space>
#
# SPDX-License-Identifier: MIT
{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnet-sdk_8,
  dotnet-aspnetcore_8,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "luarenamer";
  version = "5.10.1";

  src = fetchFromGitHub {
    owner = "Mik1ll";
    repo = "LuaRenamer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZN7o9q3APgc7vL+IRpk6Phd0Btpzyqdp53aoGp6sA8o=";
  };

  patches = [
    ./nozip.patch
  ];

  dotnet-sdk = dotnet-sdk_8;
  dotnet-runtime = dotnet-aspnetcore_8;

  nugetDeps = ./deps.json;
  projectFile = "LuaRenamer/LuaRenamer.csproj";

  executables = [ ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Mik1ll/LuaRenamer";
    changelog = "https://github.com/Mik1ll/LuaRenamer/releases/tag/${finalAttrs.src.tag}";
    description = "Plugin for Shoko that allows users to rename their collection using Lua";
    license = [
      lib.licenses.gpl3
      lib.licenses.lgpl3
    ];
    maintainers = with lib.maintainers; [ nanoyaki ];
    inherit (dotnet-sdk_8.meta) platforms;
  };
})
