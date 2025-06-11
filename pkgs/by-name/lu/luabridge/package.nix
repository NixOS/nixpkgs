{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "luabridge";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "vinniefalco";
    repo = "LuaBridge";
    rev = version;
    sha256 = "sha256-gXrBNzE41SH98Xz480+uHQlxHjMHzs23AImxil5LZ0g=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include
    cp -r Source/LuaBridge $out/include
    runHook postInstall
  '';

  meta = {
    description = "Lightweight, dependency-free library for binding Lua to C++";
    homepage = "https://github.com/vinniefalco/LuaBridge";
    changelog = "https://github.com/vinniefalco/LuaBridge/blob/${version}/CHANGES.md";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
