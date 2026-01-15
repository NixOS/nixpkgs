# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Mik1ll/LuaRenamer";
    changelog = "https://github.com/Mik1ll/LuaRenamer/releases/tag/${finalAttrs.version}";
    description = "Plugin for Shoko Server that allows users to rename their collection via an Lua 5.4 interface.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nanoyaki ];
    inherit (dotnet-sdk_8.meta) platforms;
  };
})
