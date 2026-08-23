{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  antlr4_9,
  libargs,
  catch2,
  cmake,
  yaml-cpp,
}:
let
  antlr4 = antlr4_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "luaformatter";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "Koihik";
    repo = "LuaFormatter";
    rev = finalAttrs.version;
    sha256 = "14l1f9hrp6m7z3cm5yl0njba6gfixzdirxjl8nihp9val0685vm0";
  };

  patches = [
    (replaceVars ./fix-lib-paths.patch {
      antlr4RuntimeCpp = antlr4.runtime.cpp.dev;
      yamlCpp = yaml-cpp;
      inherit libargs catch2;
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    antlr4.runtime.cpp
    yaml-cpp
  ];

  meta = {
    description = "Code formatter for Lua";
    homepage = "https://github.com/Koihik/LuaFormatter";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "lua-format";
  };
})
