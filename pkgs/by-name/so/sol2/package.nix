{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  lua,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sol2";
  version = "3.3.1";
  src = fetchFromGitHub {
    owner = "ThePhD";
    repo = "sol2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7QHZRudxq3hdsfEAYKKJydc4rv6lyN6UIt/2Zmaejx8=";
  };

  nativeBuildInputs = [
    cmake
    lua
  ];

  cmakeFlags = [
    "-DSOL2_LUA_VERSION=${lua.version}"
    "-DSOL2_BUILD_LUA=FALSE"
  ];

  meta = with lib; {
    description = "Lua API wrapper with advanced features and top notch performance";
    longDescription = ''
      sol2 is a C++ library binding to Lua.
      It currently supports all Lua versions 5.1+ (LuaJIT 2.0+ and MoonJIT included).
      sol2 aims to be easy to use and easy to add to a project.
      The library is header-only for easy integration with projects, and a single header can be used for drag-and-drop start up.
    '';
    homepage = "https://github.com/ThePhD/sol2";
    license = licenses.mit;
    maintainers = with maintainers; [ mrcjkb ];
  };
})
