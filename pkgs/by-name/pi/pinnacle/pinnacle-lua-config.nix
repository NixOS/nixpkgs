{
  lua54Packages,
  lua5_4,
}:
{ lua-client-api, ... }@args:
lua54Packages.buildLuarocksPackage (
  (removeAttrs args [ "lua-client-api" ])
  // {
    propagatedBuildInputs = [
      lua5_4
      lua-client-api
    ];
  }
)
