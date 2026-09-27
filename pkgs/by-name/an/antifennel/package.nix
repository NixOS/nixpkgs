{
  lib,
  stdenv,
  luajit,
  luapkgs ? luajit.pkgs,
  pandoc,
  fennel-ls,
  fetchFromSourcehut,
}:
stdenv.mkDerivation rec {
  pname = "antifennel";
  version = "0.3.1-unstable-2025-06-02";
  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = "antifennel";
    rev = "76b02c0252cfc8e2a56edea381f7f682b598ac37";
    hash = "sha256-6gt89ZNm91JrQo/4/0CQLpkc4xux5OGQWg87cju4vCQ=";
  };
  nativeBuildInputs = [ pandoc ];
  env.LUA = luapkgs.lua.interpreter;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  checkInputs = [
    luapkgs.luacheck
    fennel-ls
  ];
  meta = {
    mainProgram = "antifennel";
    description = "Fennel decompiler which produces fennel code from lua code";
    homepage = "https://git.sr.ht/~technomancy/antifennel";
    changelog = "https://git.sr.ht/~technomancy/antifennel/tree/${src.rev}/item/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ birdee ];
  };
}
