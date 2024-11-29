{ lua, writeText, toLuaModule }:

{ disabled ? false
, propagatedBuildInputs ? [ ]
, makeFlags ? [ ]
, ...
} @ attrs:

if disabled then
  throw "${attrs.name} not supported by interpreter lua-${lua.luaversion}"
else
  toLuaModule (lua.stdenv.mkDerivation (
    attrs // {
      name = "lua${lua.luaversion}-" + attrs.pname + "-" + attrs.version;

      makeFlags = [
        "PREFIX=$(out)"
        "LUA_INC=-I${lua}/include"
        "LUA_LIBDIR=$(out)/lib/lua/${lua.luaversion}"
        "LUA_VERSION=${lua.luaversion}"
      ] ++ makeFlags;

      propagatedBuildInputs = propagatedBuildInputs ++ [
        lua # propagate it for its setup-hook
      ];
    }
  ))
